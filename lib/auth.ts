import { SignJWT, jwtVerify } from 'jose';
import { headers } from 'next/headers';
import { cookies } from 'next/headers';
const secret=()=>{if(!process.env.AUTH_SECRET||process.env.AUTH_SECRET.length<32)throw new Error('Set AUTH_SECRET (min 32 chars)');return new TextEncoder().encode(process.env.AUTH_SECRET)};
export async function signSession(userId:string,role:string){return new SignJWT({role}).setProtectedHeader({alg:'HS256'}).setSubject(userId).setIssuedAt().setExpirationTime('8h').sign(secret())}
export async function requireRole(...roles:string[]){const h=await headers();const origin=h.get('origin');const host=h.get('x-forwarded-host')||h.get('host');if(origin&&new URL(origin).host!==host)throw new Error('Forbidden');const c=await cookies();const t=c.get('eventcrowd_session')?.value;if(!t)throw new Error('Unauthorized');const {payload}=await jwtVerify(t,secret());if(!roles.includes(String(payload.role)))throw new Error('Forbidden');return {userId:String(payload.sub),role:String(payload.role)}}
