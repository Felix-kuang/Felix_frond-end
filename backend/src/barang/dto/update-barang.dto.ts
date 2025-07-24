import { IsIn, IsNumber, IsOptional, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateBarangDto {
  @IsOptional()
  @IsString()
  nama_barang?: string;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  kategori_id?: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  stok?: number;

  @IsOptional()
  @IsString()
  @IsIn(['A', 'B', 'C'])
  kelompok_barang?: string;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  harga?: number;

  @IsOptional()
  @IsString()
  imageUrl?: string;
}
