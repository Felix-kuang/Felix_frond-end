import { BadRequestException, Injectable } from '@nestjs/common';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { UploadApiErrorResponse, UploadApiResponse } from 'cloudinary';

function isCloudinaryErrorResponse(
  result: UploadApiResponse | UploadApiErrorResponse,
): result is UploadApiErrorResponse {
  return 'error' in result;
}

@Injectable()
export class MediaService {
  constructor(private cloudinary: CloudinaryService) {}

  async uploadImageToCloudinary(
    file: Express.Multer.File,
  ): Promise<{ message: string; url: string }> {
    try {
      const result: UploadApiResponse | UploadApiErrorResponse =
        await this.cloudinary.uploadImage(file);

      if (isCloudinaryErrorResponse(result)) {
        throw new BadRequestException(
          (result.error as { message?: string })?.message ??
            'Invalid File Type',
        );
      }

      return {
        message: 'File berhasil diupload',
        url: result.secure_url,
      };
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Upload Failed';
      throw new BadRequestException(message);
    }
  }

  async deleteImageFromCloudinary(
    publicId: string,
  ): Promise<{ message: string }> {
    await this.cloudinary.deleteImage(publicId); // now throws if fails
    return { message: 'Image deleted successfully' };
  }
}
