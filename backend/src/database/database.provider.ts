import { createPool } from 'mysql2/promise';
import { Provider } from '@nestjs/common';
import {
  DB_HOST,
  DB_NAME,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
} from '../../utils/env';
import { DB_CONNECTION } from './constants';


export const DatabaseProvider: Provider = {
  provide: DB_CONNECTION,
  useFactory: () => {
    return createPool({
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PASSWORD,
      database: DB_NAME,
    });
  },
};
