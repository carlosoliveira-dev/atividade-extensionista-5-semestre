import 'package:flutter/material.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
  static final ValueNotifier<double> textScaleFactorNotifier = ValueNotifier(1.0);

  static const Color primaryColor = Color(0xFF005AC1);
  static const Color secondaryColor = Color(0xFF006874);
  static const Color tertiaryColor = Color(0xFF6750A4);
  static const Color backgroundColor = Color(0xFFF8FDFF);

  static void abrirMenuAcessibilidade(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.accessibility_new_outlined, size: 28),
                SizedBox(width: 12),
                Text(
                  'Painel de Acessibilidade',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Aparência / Tema', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, themeMode, _) {
                return SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Escuro'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Sistema'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (newSelection) {
                    themeModeNotifier.value = newSelection.first;
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Tamanho da Fonte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            ValueListenableBuilder<double>(
              valueListenable: textScaleFactorNotifier,
              builder: (context, scale, _) {
                final percent = (scale * 100).round();
                return Column(
                  children: [
                    Text('$percent%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.remove),
                          label: const Text('Menor'),
                          onPressed: scale > 0.8
                              ? () => textScaleFactorNotifier.value = (scale - 0.15).clamp(0.8, 1.6)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => textScaleFactorNotifier.value = 1.0,
                          child: const Text('Padrão'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.add),
                          label: const Text('Maior'),
                          onPressed: scale < 1.6
                              ? () => textScaleFactorNotifier.value = (scale + 0.15).clamp(0.8, 1.6)
                              : null,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: const Color(0xFF9ECAFF),
        secondary: const Color(0xFF4FD8EB),
        tertiary: const Color(0xFFD0BCFF),
        surface: const Color(0xFF111318),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
