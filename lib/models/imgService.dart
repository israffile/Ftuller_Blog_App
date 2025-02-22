import 'dart:developer';
import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

final cloudinary = Cloudinary.signedConfig(
  apiKey: "165586716368829",
  apiSecret: "3mQlAX8AqytPvdxMVdYxvSW3f6I",
  cloudName: "dpatoxgpc",
);

Future<String?> uploadCloudinary (Uint8List? img) async {
  if (img == null) {
    return null;
  }
  try {
    CloudinaryResponse response = await cloudinary.upload(
      fileBytes: img,
      resourceType: CloudinaryResourceType.image,
      folder: "userPosting",
    );
    print("upload success");
    print(response.secureUrl.toString());
    return response.secureUrl.toString();
  } catch (e) {
    log(e.toString(), name: "upload time error");
    
  }
  return null;
}

Future<Uint8List?> compressImage(Uint8List inputImage) async{
  try {
      img.Image? decodedImage = img.decodeImage(inputImage);

  if (decodedImage == null) {
    throw Exception("Unable to decode image");
  }

  decodedImage = img.copyResize(decodedImage,
      width: decodedImage.width > 600 ? 600 : decodedImage.width,
      height: decodedImage.height > 800
          ? 800
          : decodedImage.height); // Resize to a width of 800px

  // Compress the image by re-encoding it with a quality value
  Uint8List compressedImage = Uint8List.fromList(
    img.encodeJpg(decodedImage, quality: 80),
  );

  return compressedImage;
  } catch (e) {
    log(e.toString(), name: 'compressImage func');
    return null;

  }
  
}

Future<void> deleteFromCloudinary(String? url) async {
  if (url == null) {
    return;
  }
  try {
    // Extract the public ID from the URL
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    // Form the public ID by skipping 'image/' and 'upload/'
    final publicId = pathSegments
        .skip(2)
        .join('/')
        .replaceFirst(RegExp(r'upload/'), '')
        .replaceFirst(RegExp(r'v\d+/'), '')
        .replaceFirst(RegExp(r'\.\w+$'), '');

    log(publicId, name: 'delete publicId');

    // Use the public ID to delete the resource
    CloudinaryResponse response = await cloudinary.destroy(publicId);

    if (response.isSuccessful) {
      log('File deleted successfully', name: 'delete response');
    } else {
      log('Failed to delete file: ${response.error}', name: 'delete response');
    }
  } catch (e) {
    log(e.toString(), name: 'delete cloudinary func');
  }
}

Future<Uint8List?> urlToImageUint8List(String? url) async {
  if (url == null) {
    return null;
  }
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  if (response.statusCode == 200) {
    return bytes;
  } else {
    return null;
  }
}


