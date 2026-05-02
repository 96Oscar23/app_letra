import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';

class RepertoriesPage extends StatelessWidget {
  const RepertoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: const [
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Repertorios'),
            subtitle: Text(
              'En fase 1 queda como módulo parcial. La base visual y el acceso ya están listos.',
            ),
          ),
        ),
        SizedBox(height: 16),
        EmptyState(
          icon: Icons.queue_music_outlined,
          title: 'Módulo parcial',
          message:
              'La fase 1 se centra en cantos locales. Repertorios puede crecer en la siguiente fase sin romper esta estructura.',
        ),
      ],
    );
  }
}
