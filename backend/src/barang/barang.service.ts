import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Pool, ResultSetHeader, RowDataPacket } from 'mysql2/promise';
import { CreateBarangDto } from './dto/create-barang.dto';
import { DB_CONNECTION } from '../database/constants';
import { UpdateBarangDto } from './dto/update-barang.dto';

@Injectable()
export class BarangService {
  constructor(@Inject(DB_CONNECTION) private readonly db: Pool) {}

  async findAll(search?: string) {
    let query = `
      SELECT b.id,
             b.nama_barang,
             b.stok,
             b.kelompok_barang,
             b.harga,
             k.nama_kategori,
             b.imageUrl
      FROM barang b
             JOIN kategori k ON b.kategori_id = k.id
    `;
    const values: any[] = [];

    if (search) {
      query += ' WHERE nama_barang LIKE ?';
      values.push(`%${search}%`);
    }

    const [rows] = await this.db.query(query, values);
    return rows;
  }

  async findById(id: number) {
    const query = `
      SELECT b.id,
             b.nama_barang,
             b.stok,
             b.kelompok_barang,
             b.harga,
             k.nama_kategori,
             b.imageUrl
      FROM barang b
             JOIN kategori k ON b.kategori_id = k.id
      WHERE b.id = ?
      LIMIT 1
    `;
    const [rows] = await this.db.query<RowDataPacket[]>(query, [id]);

    const item = rows[0];
    if (!item) {
      throw new NotFoundException(`Barang dengan id ${id} tidak ditemukan`);
    }

    return item;
  }

  async create(dto: CreateBarangDto) {
    const query = `
      INSERT INTO barang (nama_barang, kategori_id, stok, kelompok_barang, harga, imageUrl)
      VALUES (?, ?, ?, ?, ?, ?);
    `;

    const values = [
      dto.nama_barang.trim(),
      dto.kategori_id,
      dto.stok,
      dto.kelompok_barang.toUpperCase(),
      dto.harga,
      dto.imageUrl?.trim() ?? 'https://placehold.co/600x400',
    ];

    const [result] = await this.db.query<ResultSetHeader>(query, values);

    return {
      message: 'Barang berhasil ditambahkan',
      id: result.insertId,
    };
  }

  async update(id: number, dto: UpdateBarangDto) {
    const fields: string[] = [];
    const values: (string | number)[] = [];

    for (const key in dto) {
      const value = dto[key as keyof UpdateBarangDto];
      if (typeof value !== 'undefined') {
        fields.push(`${key} = ?`);
        values.push(
          //jika fieldnya kelompok barang dan string, maka set ke Uppercase
          //jika tidak masukkan seperti biasa
          key === 'kelompok_barang' && typeof value === 'string'
            ? value.toUpperCase()
            : value,
        );
      }
    }

    if (fields.length === 0) {
      throw new BadRequestException('Tidak ada data untuk diupdate');
    }

    const query = `UPDATE barang
                   SET ${fields.join(',')}
                   WHERE id = ?`;

    values.push(id);

    await this.db.query(query, values);
    return { message: 'Barang berhasil diupdate' };
  }

  async delete(id: number) {
    const query = `DELETE
                   FROM barang
                   WHERE id = ?`;
    await this.db.query(query, [id]);

    return { message: 'Barang berhasil dihapus' };
  }

  async deleteBulk(ids: number[]) {
    const numIds = ids.map(Number);
    //jika kosong atau ada yang bukan number
    if (!numIds.length || numIds.some(isNaN)) {
      throw new BadRequestException('ID tidak valid');
    }

    const placeholders = numIds.map(() => '?').join(',');
    const query = `DELETE
                   FROM barang
                   WHERE id IN (${placeholders})`;

    await this.db.query(query, numIds);

    return { message: `${numIds.length} barang berhasil dihapus` };
  }
}
