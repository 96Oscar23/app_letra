import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.songCount,
    required this.favoriteCount,
    required this.onOpenSongs,
    required this.onOpenFavorites,
    required this.onOpenSettings,
    required this.onOpenSearch,
  });

  final int songCount;
  final int favoriteCount;
  final VoidCallback onOpenSongs;
  final VoidCallback onOpenFavorites;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        Text(
          'Tu biblioteca local',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Fase 1 enfocada en cantos offline, favoritos, lectura y ajustes base.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: wide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: wide ? 1.35 : 1.1,
          children: [
            _QuickCard(
              title: 'Mis cantos',
              subtitle: '$songCount guardados',
              icon: Icons.library_music_outlined,
              color: AppColors.primary,
              onTap: onOpenSongs,
            ),
            _QuickCard(
              title: 'Favoritos',
              subtitle: '$favoriteCount marcados',
              icon: Icons.favorite_outline,
              color: AppColors.tertiary,
              onTap: onOpenFavorites,
            ),
            _QuickCard(
              title: 'Buscar',
              subtitle: 'Por nombre o letra',
              icon: Icons.search,
              color: AppColors.secondary,
              onTap: onOpenSearch,
            ),
            _QuickCard(
              title: 'Ajustes',
              subtitle: 'Lectura y visual',
              icon: Icons.tune,
              color: AppColors.textSecondary,
              onTap: onOpenSettings,
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado de la fase 1',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const _StatusRow(label: 'Base local de cantos', value: 'Lista'),
              const _StatusRow(label: 'Favoritos', value: 'Activo'),
              const _StatusRow(label: 'Busqueda basica', value: 'Activa'),
              const _StatusRow(label: 'Modo repertorios', value: 'Parcial'),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(color: AppColors.primary)),
        ],
      ),
    );
  }
}
