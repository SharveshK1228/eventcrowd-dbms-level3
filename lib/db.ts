import { Pool } from 'pg';
import { MongoClient } from 'mongodb';
const globalForDb=globalThis as unknown as {pg?:Pool; mongo?:MongoClient};
export function postgres(){if(!process.env.DATABASE_URL)throw new Error('DATABASE_URL missing');return globalForDb.pg??(globalForDb.pg=new Pool({connectionString:process.env.DATABASE_URL,max:10}));}
export async function mongo(){if(!process.env.MONGODB_URI)throw new Error('MONGODB_URI missing');const c=globalForDb.mongo??(globalForDb.mongo=new MongoClient(process.env.MONGODB_URI));await c.connect();return c.db(process.env.MONGODB_DB||'eventcrowd');}
