import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  /// RF02 - Compressão de Imagens no Cliente:
  /// Redimensiona e reduz a qualidade da imagem localmente antes do envio POST
  static Future<File> compressImage(File file, {int maxWidth = 1080, int quality = 70}) async {
    try {
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);

      if (decoded == null) return file;

      img.Image resized = decoded;
      if (decoded.width > maxWidth) {
        resized = img.copyResize(decoded, width: maxWidth);
      }

      final compressedBytes = img.encodeJpg(resized, quality: quality);

      final tempDir = await getTemporaryDirectory();
      final fileName = 'compressed_${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
      final compressedFile = File(p.join(tempDir.path, fileName));

      await compressedFile.writeAsBytes(compressedBytes);
      return compressedFile;
    } catch (e) {
      // Fallback em caso de falha de decodificação
      return file;
    }
  }
}
