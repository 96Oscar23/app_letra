import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final settings = controller.settings;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tamaño de letra',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('A-'),
                      Expanded(
                        child: Slider(
                          value: settings.fontScale,
                          min: 0.85,
                          max: 1.6,
                          divisions: 15,
                          label: settings.fontScale.toStringAsFixed(2),
                          onChanged: (value) {
                            controller.setFontScale(value);
                          },
                        ),
                      ),
                      const Text('A+'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mostrar acordes'),
                    subtitle: const Text('Persistido localmente desde fase 1.'),
                    value: settings.showChords,
                    onChanged: (value) {
                      controller.toggleShowChords(value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mantener pantalla encendida'),
                    subtitle: const Text(
                      'El ajuste queda listo para lectura continua.',
                    ),
                    value: settings.keepScreenAwake,
                    onChanged: (value) {
                      controller.toggleKeepScreenAwake(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline, color: AppColors.primary),
                title: Text('Lumen Vesper'),
                subtitle: Text('Base de fase 1 con lectura offline.'),
              ),
            ),
          ],
        );
      },
    );
  }
}
