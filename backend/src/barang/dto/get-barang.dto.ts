import { IsOptional, IsString } from 'class-validator';

export class GetBarangDto {
  @IsOptional()
  @IsString()
  search?: string;
}
