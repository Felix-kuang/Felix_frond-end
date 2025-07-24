import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { MediaService } from './media.service';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('media')
export class MediaController {
  constructor(private readonly mediaService: MediaService) {}

  @Post()
  @UseInterceptors(FileInterceptor('file'))
  async uploadImage(@UploadedFile() file: Express.Multer.File) {
    const allowedMimeTypes = [
      'image/png',
      'image/jpeg',
      'image/jpg',
      'image/webp',
    ];

    if (!file || !file.buffer) {
      throw new BadRequestException('File is required');
    }

    if (!allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type');
    }

    return this.mediaService.uploadImageToCloudinary(file);
  }

  @Delete('delete')
  async deleteImage(@Body('public_id') publicId: string) {
    if (!publicId) {
      throw new BadRequestException('public_id is required');
    }

    return this.mediaService.deleteImageFromCloudinary(publicId);
  }
}
