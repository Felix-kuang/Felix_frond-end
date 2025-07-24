import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { KategoriController } from './kategori/kategori.controller';
import { KategoriService } from './kategori/kategori.service';
import { KategoriModule } from './kategori/kategori.module';
import { DatabaseModule } from './database/database.module';
import { BarangModule } from './barang/barang.module';
import { CloudinaryService } from './cloudinary/cloudinary.service';
import { CloudinaryModule } from './cloudinary/cloudinary.module';
import { MediaModule } from './media/media.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    KategoriModule,
    DatabaseModule,
    BarangModule,
    CloudinaryModule,
    MediaModule,
  ],
  controllers: [AppController, KategoriController],
  providers: [DatabaseModule, AppService, KategoriService, CloudinaryService],
})
export class AppModule {}
