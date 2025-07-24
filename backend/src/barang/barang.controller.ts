import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { BarangService } from './barang.service';
import { GetBarangDto } from './dto/get-barang.dto';
import { CreateBarangDto } from './dto/create-barang.dto';
import { UpdateBarangDto } from './dto/update-barang.dto';

@Controller('barang')
export class BarangController {
  constructor(private readonly barangService: BarangService) {}

  @Get()
  async findAll(@Query() query: GetBarangDto) {
    return this.barangService.findAll(query.search);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.barangService.findById(Number(id));
  }

  @Post()
  async create(@Body() barangDto: CreateBarangDto) {
    return this.barangService.create(barangDto);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() barangDto: UpdateBarangDto) {
    return this.barangService.update(Number(id), barangDto);
  }

  @Delete('bulk')
  async bulkDelete(@Body() body: { ids: number[] }) {
    return this.barangService.deleteBulk(body.ids);
  }

  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.barangService.delete(Number(id));
  }
}
