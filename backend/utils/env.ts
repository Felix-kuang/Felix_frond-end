import * as process from 'node:process';
import * as dotenv from 'dotenv';
dotenv.config();

export const DB_HOST: string = process.env.DB_HOST || '';
export const DB_PORT: number = parseInt(process.env.DB_PORT || '3306', 10);
export const DB_USER: string = process.env.DB_USER || '';
export const DB_PASSWORD: string = process.env.DB_PASSWORD || '';
export const DB_NAME: string = process.env.DB_NAME || '';

export const CLOUDINARY_CLOUD_NAME: string =
  process.env.CLOUDINARY_CLOUD_NAME || '';
export const CLOUDINARY_API_KEY: string = process.env.CLOUDINARY_API_KEY || '';
export const CLOUDINARY_API_SECRET: string =
  process.env.CLOUDINARY_API_SECRET || '';
