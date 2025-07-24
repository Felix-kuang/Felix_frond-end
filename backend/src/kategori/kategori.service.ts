import { Inject, Injectable } from '@nestjs/common';
import { Pool } from 'mysql2/promise';
import { DB_CONNECTION } from '../database/constants';

@Injectable()
export class KategoriService {
  constructor(@Inject(DB_CONNECTION) private readonly db: Pool) {}

  async findAll() {
    const [rows] = await this.db.query('SELECT * FROM kategori');
    return rows;
  }
}
