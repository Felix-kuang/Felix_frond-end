import { Injectable } from '@nestjs/common';
import { UploadApiErrorResponse, UploadApiResponse, v2 } from 'cloudinary';

type CloudinaryDeleteResponse = {
  result: string;
};

@Injectable()
export class CloudinaryService {
  async uploadImage(
    file: Express.Multer.File,
  ): Promise<UploadApiResponse | UploadApiErrorResponse> {
    return new Promise((resolve, reject) => {
      const upload = v2.uploader.upload_stream((error, result) => {
        if (error) return reject(new Error(error?.message ?? 'Upload failed'));

        if (!result) {
          return reject(new Error('No result returned from Cloudinary'));
        }

        resolve(result);
      });

      upload.end(file.buffer);
    });
  }

  async deleteImage(publicId: string): Promise<'ok'> {
    const result = (await v2.uploader.destroy(
      publicId,
    )) as CloudinaryDeleteResponse;

    if (result.result !== 'ok') {
      throw new Error(`Failed to delete image:${publicId}`);
    }

    return 'ok';
  }
}
