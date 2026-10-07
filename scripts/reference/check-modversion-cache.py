#!/usr/bin/env python3
"""Check Kbuild export metadata; optionally invalidate only incomplete .cmd files.

Never writes CRCs, symbol tables, kernel config or module files. A missing .cmd
forces Kbuild to compile the original source and run its native genksyms recipe.
"""
import argparse, hashlib, json, pathlib, re, shutil, subprocess, time
p=argparse.ArgumentParser();p.add_argument('--cache',required=True);p.add_argument('--nm',required=True)
p.add_argument('--report',required=True);p.add_argument('--invalidate-missing',action='store_true');p.add_argument('--backup')
p.add_argument('--bazel-output-image');p.add_argument('--bazel-output-root')
a=p.parse_args();c=pathlib.Path(a.cache).resolve();index=c/'.vmlinux.objs'
r={'cache':str(c),'objects_checked':0,'export_objects':0,'missing_metadata':[],'invalidated_cmd_files':[],'timestamp_ns':time.time_ns()}
if index.exists():
    objects=[c/x for x in index.read_text().splitlines() if x.strip()]
    exports={}
    for start in range(0,len(objects),100):
        batch=objects[start:start+100]
        q=subprocess.run([a.nm,'--defined-only','--format=posix','--print-file-name',*[str(o) for o in batch]],capture_output=True,text=True)
        if q.returncode:raise RuntimeError('llvm-nm failed; cannot trust metadata check: '+q.stderr[:2000])
        for line in q.stdout.splitlines():
            match=re.match(r'(.+?):\s+__export_symbol_(\S+)\s',line)
            if match:exports.setdefault(pathlib.Path(match[1]),set()).add(match[2])
        r['objects_checked']+=len(batch)
    r['export_objects']=len(exports)
    for obj,names in sorted(exports.items()):
        cmd=obj.with_name('.'+obj.name+'.cmd')
        text=cmd.read_text() if cmd.exists() else ''
        versions=dict(re.findall(r'^#SYMVER (\S+) (0x[0-9a-fA-F]+)$',text,re.M))
        missing=sorted(names-set(versions))
        if not missing:continue
        r['missing_metadata'].append({'object':str(obj),'cmd':str(cmd),'missing_symbols':missing,'symversion_count':len(versions)})
        if a.invalidate_missing:
            if not a.backup:raise ValueError('--backup required for invalidation')
            dest=pathlib.Path(a.backup)/obj.relative_to(c);dest.parent.mkdir(parents=True,exist_ok=True)
            for src in [obj,cmd]:
                if src.exists():shutil.copy2(src,dest if src==obj else dest.with_name('.'+dest.name+'.cmd'))
            # Only metadata is invalidated. Native Kbuild will rebuild the object.
            if cmd.exists():
                resolved=cmd.resolve();assert c in resolved.parents
                entry={'path':str(cmd),'sha256':hashlib.sha256(cmd.read_bytes()).hexdigest()}
                cmd.unlink();r['invalidated_cmd_files'].append(entry)
else:r['skipped']='No existing .vmlinux.objs; no previous compiled cache to check'
if r['missing_metadata'] and a.invalidate_missing and a.bazel_output_image:
    # Persistent OUT_DIR files are not Bazel inputs. Removing only a declared
    # output makes Bazel rerun its producer; make then uses the retained cache.
    image=pathlib.Path(a.bazel_output_image).resolve()
    root=pathlib.Path(a.bazel_output_root).resolve()
    assert root in image.parents and image.parts[-3:]==('common','kernel_aarch64','Image')
    if image.is_file():
        backup=pathlib.Path(a.backup)/'Bazel-Image.before-recovery';shutil.copy2(image,backup)
        r['invalidated_bazel_output']={'path':str(image),'sha256':hashlib.sha256(image.read_bytes()).hexdigest(),'backup':str(backup)}
        image.unlink()
dest=pathlib.Path(a.report);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(json.dumps(r,indent=2))
print(json.dumps(r,indent=2))
if r['missing_metadata'] and not a.invalidate_missing:raise SystemExit(1)
