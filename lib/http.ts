import {NextResponse} from 'next/server';
import {ZodError} from 'zod';
export function failure(e:unknown){const message=e instanceof Error?e.message:'';const status=message==='Unauthorized'?401:message==='Forbidden'?403:e instanceof ZodError?400:message.startsWith('Conflict:')?409:400;return NextResponse.json({error:e instanceof ZodError?'Invalid input':status===401||status===403?message:message.startsWith('Conflict:')?message:'Request could not be completed. Check input and permissions.'},{status});}
