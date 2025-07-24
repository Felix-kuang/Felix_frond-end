import { IsIn, IsNumber, IsOptional, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateBarangDto {
  @IsString()
  nama_barang: string;

  @Type(() => Number)
  @IsNumber()
  kategori_id: number;

  @Type(() => Number)
  @IsNumber()
  stok: number;

  @IsString()
  @IsIn(['A', 'B', 'C'])
  kelompok_barang: string;

  @Type(() => Number)
  @IsNumber()
  harga: number;

  @IsOptional()
  @IsString()
  imageUrl?: string;
}
