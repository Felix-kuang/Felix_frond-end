import { Controller, Get } from '@nestjs/common';
import { KategoriService } from './kategori.service';

@Controller('kategori')
export class KategoriController {
  constructor(private kategoriService: KategoriService) {}

  @Get()
  async getAllKategori() {
    return this.kategoriService.findAll();
  }
}
