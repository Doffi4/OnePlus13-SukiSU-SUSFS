#!/usr/bin/env node
// SPDX-License-Identifier: MIT
'use strict';
// Local documentation checks only. Does not build, install, flash or access a phone.
const fs=require('fs'), path=require('path'), crypto=require('crypto');
const root=path.resolve(__dirname,'..');
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
function files(dir) { return fs.readdirSync(dir,{withFileTypes:true}).filter(e=>e.name!=='.git').flatMap(e=>e.isDirectory()?files(path.join(dir,e.name)):[path.join(dir,e.name)]); }
const inventory=files(root).map(p=>({path:path.relative(root,p).replace(/\\/g,'/'),bytes:fs.statSync(p).size,sha256:sha(fs.readFileSync(p))})).sort((a,b)=>a.path.localeCompare(b.path));
let links=0,jsons=0;const issues=[];
for(const file of inventory) {
 const p=path.join(root,file.path), s=fs.readFileSync(p,'utf8');
 if(/\.(?:img|apk|zip|ko|der|pem|key|jks|p12|o|pyc)$/i.test(file.path)||/(?:^|\/)(?:Image|vmlinux|__pycache__|cache|bazel-[^/]+)(?:\/|$)/.test(file.path)) issues.push('Excluded artifact: '+file.path);
 if(/-----BEGIN (?:RSA |EC |OPENSSH |ENCRYPTED )?PRIVATE KEY-----/.test(s)) issues.push('Private key marker: '+file.path);
 if(/\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[A-Z0-9]{16})\b/.test(s)) issues.push('Credential pattern: '+file.path);
 if(file.path.endsWith('.json')) { try{JSON.parse(s);jsons++;}catch(e){issues.push('Invalid JSON '+file.path+': '+e.message);} }
 if(file.path.endsWith('.md')) {
  if(/(?:\b[A-Za-z]:[\\/]|\/mnt\/[a-z]\/Users\/|\/home\/doffi4\/)/.test(s)) issues.push('Machine-local path in Markdown: '+file.path);
  const withoutFences=s.replace(/^(```|~~~)[\s\S]*?^\1[^\n]*$/gm,'');
  for(const m of withoutFences.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
   const link=m[1].trim().replace(/^<|>$/g,'').split(/\s+"/)[0];
   if(/^(?:https?:|mailto:|#)/.test(link))continue;
   const dst=path.resolve(path.dirname(p),decodeURIComponent(link.split('#')[0]));links++;
   if(!dst.startsWith(root+path.sep)||!fs.existsSync(dst))issues.push('Broken/outside link '+file.path+': '+link);
  }
 }
}
const index=JSON.parse(fs.readFileSync(path.join(root,'provenance/evidence-index.json'),'utf8'));
for(const f of index.files) { const target=path.join(root,f.destination);if(!fs.existsSync(target)||sha(fs.readFileSync(target))!==f.destination_sha256)issues.push('Provenance hash mismatch: '+f.destination); }
const summary={result:issues.length?'FAIL':'PASS',files:inventory.length,relative_links_checked:links,json_files_parsed:jsons,provenance_files_checked:index.files.length,credential_or_excluded_artifact_findings:issues,scope:'Local link/hash/JSON/inventory checks; external URLs and kernel/device behavior are not tested',inventory};
console.log(JSON.stringify(summary,null,2));if(issues.length)process.exitCode=1;
