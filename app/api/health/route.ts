import {NextResponse} from 'next/server';import {postgres,mongo} from '../../../lib/db';
export const dynamic='force-dynamic';
export async function GET(){try{await postgres().query('SELECT 1');const m=await mongo();await m.command({ping:1});return NextResponse.json({status:'ok',postgres:'connected',mongodb:'connected'})}catch{return NextResponse.json({status:'unavailable'},{status:503})}}
