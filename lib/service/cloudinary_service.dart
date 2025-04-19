import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:untitled/service/cloudinary_config.dart';

class CloudinaryService {
  // Private constructor
  CloudinaryService._privateConstructor();

  // Static instance
  static final CloudinaryService _instance =
      CloudinaryService._privateConstructor();

  // Static getter for the instance
  static CloudinaryService get instance => _instance;

  Future<String> uploadImage(String imagePath) async {
    final cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );

    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(imagePath,
          resourceType: CloudinaryResourceType.Image),
    );

    return response.secureUrl;
  }

  Future<String> uploadVideo(String videoPath) async {
    final cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );

    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(videoPath,
          resourceType: CloudinaryResourceType.Video),
    );

    return response.secureUrl;
  }
}
