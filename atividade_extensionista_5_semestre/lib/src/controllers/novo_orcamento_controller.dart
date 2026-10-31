import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/utils/image_compressor.dart';
import '../models/orcamento_model.dart';
import '../repositories/orcamento_repository.dart';

class NovoOrcamentoController extends ChangeNotifier {
  final OrcamentoRepository repository;

  NovoOrcamentoController({OrcamentoRepository? repository})
      : repository = repository ?? OrcamentoRepository();

  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final veiculoModeloController = TextEditingController();
  final veiculoPlacaController = TextEditingController();
  final descricaoDanoController = TextEditingController();

  final List<File> fotosSelecionadas = [];
  final List<String> fotosCategorias = [];

  bool isLoading = false;
  String? errorMessage;
  OrcamentoModel? orcamentoCriado;

  final List<String> categoriasGuiadas = [
    'Frente / Parachoque Dianteiro',
    'Lateral Esquerda / Portas',
    'Lateral Direita / Portas',
    'Traseira / Parachoque',
    'Teto / Capô / Detalhe',
  ];

  Future<void> selecionarFoto(int index, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final fileOriginal = File(pickedFile.path);
        final fileComprimido = await ImageCompressor.compressImage(fileOriginal);

        final cat = index < categoriasGuiadas.length
            ? categoriasGuiadas[index]
            : 'Ângulo Extra ${index + 1}';

        if (index < fotosSelecionadas.length) {
          fotosSelecionadas[index] = fileComprimido;
          fotosCategorias[index] = cat;
        } else {
          fotosSelecionadas.add(fileComprimido);
          fotosCategorias.add(cat);
        }
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Erro ao selecionar foto: $e';
      notifyListeners();
    }
  }

  void removerFoto(int index) {
    if (index >= 0 && index < fotosSelecionadas.length) {
      fotosSelecionadas.removeAt(index);
      fotosCategorias.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> adicionarFotoDeCaminho(int index, String path) async {
    try {
      final fileOriginal = File(path);
      final fileComprimido = await ImageCompressor.compressImage(fileOriginal);

      final cat = index < categoriasGuiadas.length
          ? categoriasGuiadas[index]
          : 'Ângulo Extra ${index + 1}';

      if (index < fotosSelecionadas.length) {
        fotosSelecionadas[index] = fileComprimido;
        fotosCategorias[index] = cat;
      } else {
        fotosSelecionadas.add(fileComprimido);
        fotosCategorias.add(cat);
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro ao processar foto da câmera: $e';
      notifyListeners();
    }
  }

  Future<bool> enviarSolicitacao() async {
    if (nomeController.text.trim().isEmpty) {
      errorMessage = 'Por favor, informe seu nome completo.';
      notifyListeners();
      return false;
    }

    if (telefoneController.text.trim().isEmpty) {
      errorMessage = 'Por favor, informe seu WhatsApp/telefone para contato.';
      notifyListeners();
      return false;
    }

    if (veiculoPlacaController.text.trim().isEmpty) {
      errorMessage = 'Por favor, informe a placa do seu veículo.';
      notifyListeners();
      return false;
    }

    if (fotosSelecionadas.length < 3 || fotosSelecionadas.length > 5) {
      errorMessage = 'Por favor, anexe obrigatoriamente de 3 a 5 fotos do dano.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final List<Map<String, String>> fotosPayload = [];
      for (int i = 0; i < fotosSelecionadas.length; i++) {
        final bytes = await fotosSelecionadas[i].readAsBytes();
        final base64String = base64Encode(bytes);
        fotosPayload.add({
          'caminhoArquivo': base64String,
          'urlAcesso': base64String,
          'ordemCategoria': fotosCategorias[i],
        });
      }

      final payload = {
        'clienteNome': nomeController.text.trim(),
        'clienteTelefone': telefoneController.text.trim(),
        'veiculoModelo': veiculoModeloController.text.trim(),
        'veiculoPlaca': veiculoPlacaController.text.trim().toUpperCase(),
        'descricaoDano': descricaoDanoController.text.trim(),
        'fotos': fotosPayload,
      };

      orcamentoCriado = await repository.enviarOrcamento(payload);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao enviar solicitação: ${e.toString().replaceAll('Exception: ', '')}';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    veiculoModeloController.dispose();
    veiculoPlacaController.dispose();
    descricaoDanoController.dispose();
    super.dispose();
  }
}
