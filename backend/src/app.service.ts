import { Inject, Injectable } from '@nestjs/common';
import { Pool } from 'mysql2/promise';

@Injectable()
export class AppService {
  constructor(@Inject('MYSQL_CONNECTION') private readonly db: Pool) {}

  async testConnection() {
    try {
      const [rows] = await this.db.query('SELECT 1 + 1 AS result');
      return rows;
    } catch (error: unknown) {
      if (error instanceof Error) {
        throw new Error(`Failed to connect to DB: ${error.message}`);
      }
      throw new Error('Failed to connect to DB: Unknown error');
    }
  }
}
