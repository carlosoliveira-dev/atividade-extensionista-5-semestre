import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/novo_orcamento_controller.dart';

class FotoPickerGrid extends StatelessWidget {
  final NovoOrcamentoController controller;

  const FotoPickerGrid({super.key, required this.controller});

  void _exibirOpcoesPicker(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tirar Foto da Câmera'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.selecionarFoto(index, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Escolher da Galeria'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.selecionarFoto(index, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Evidências Visuais (Fotos do Dano)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${controller.fotosSelecionadas.length}/5 (Mínimo 3)',
              style: TextStyle(
                color: controller.fotosSelecionadas.length >= 3
                    ? Colors.green
                    : Colors.orange.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Posicione a câmera para capturar os ângulos sugeridos. As fotos serão comprimidas automaticamente.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final hasPhoto = index < controller.fotosSelecionadas.length;
            final catName = index < controller.categoriasGuiadas.length
                ? controller.categoriasGuiadas[index]
                : 'Foto Extra ${index + 1}';

            if (hasPhoto) {
              final file = controller.fotosSelecionadas[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => controller.removerFoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      color: Colors.black.withValues(alpha: 0.6),
                      child: Text(
                        catName,
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            }

            return InkWell(
              onTap: () => _exibirOpcoesPicker(context, index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: index < 3 ? primaryColor.withValues(alpha: 0.5) : Colors.grey.shade400,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: index < 3 ? primaryColor : Colors.grey,
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      catName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: index < 3 ? primaryColor : Colors.grey.shade700,
                        fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
