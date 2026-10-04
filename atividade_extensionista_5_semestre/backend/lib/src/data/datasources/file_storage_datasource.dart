import 'dart:io';
import 'package:path/path.dart' as p;

class FileStorageDatasource {
  final String uploadDirectory;

  FileStorageDatasource({this.uploadDirectory = 'uploads'});

  Future<String> salvarArquivo(List<int> bytes, String nomeOriginal) async {
    final dir = Directory(uploadDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final extensao = p.extension(nomeOriginal);
    final nomeUnico = 'foto_${DateTime.now().millisecondsSinceEpoch}_${bytes.hashCode.abs()}$extensao';
    final caminhoCompleto = p.join(uploadDirectory, nomeUnico);

    final arquivo = File(caminhoCompleto);
    await arquivo.writeAsBytes(bytes);

    return caminhoCompleto;
  }
}
