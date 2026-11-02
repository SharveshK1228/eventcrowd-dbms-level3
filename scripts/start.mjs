// One Railway service supervises web + worker on the three-service free plan.
import {spawn} from 'node:child_process';
let stopping=false,exitCode=0,killTimer;
const children=[
  spawn(process.execPath,['node_modules/next/dist/bin/next','start','-H','0.0.0.0'],{stdio:'inherit'}),
  spawn(process.execPath,['scripts/outbox-worker.mjs'],{stdio:'inherit'})
];
function stop(code){if(stopping)return;stopping=true;exitCode=code;for(const c of children)c.kill('SIGTERM');killTimer=setTimeout(()=>{for(const c of children)c.kill('SIGKILL')},10000);killTimer.unref()}
for(const c of children){c.on('error',()=>stop(1));c.on('exit',(code,signal)=>{if(!stopping)stop(code||1);if(children.every(p=>p.exitCode!==null||p.signalCode!==null)){clearTimeout(killTimer);process.exit(exitCode)}})}
process.on('SIGTERM',()=>stop(0));process.on('SIGINT',()=>stop(0));
