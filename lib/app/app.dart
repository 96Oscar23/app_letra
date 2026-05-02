import 'package:flutter/material.dart';

import '../features/settings/settings_controller.dart';
import '../features/shell/presentation/app_shell.dart';
import '../features/songs/songs_controller.dart';
import 'app_scope.dart';
import 'bootstrap/app_dependencies.dart';
import 'theme/app_theme.dart';

class LumenVesperApp extends StatefulWidget {
  const LumenVesperApp({
    super.key,
    required this.dependencies,
  });

  final AppDependencies dependencies;

  @override
  State<LumenVesperApp> createState() => _LumenVesperAppState();
}

class _LumenVesperAppState extends State<LumenVesperApp> {
  late final SongsController _songsController;
  late final SettingsController _settingsController;
  late final Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _songsController = SongsController(widget.dependencies.songRepository);
    _settingsController =
        SettingsController(widget.dependencies.settingsRepository);
    _bootstrapFuture = _initialize();
  }

  Future<void> _initialize() async {
    await _settingsController.load();
    await _songsController.initialize();
  }

  @override
  void dispose() {
    _songsController.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      songsController: _songsController,
      settingsController: _settingsController,
      child: AnimatedBuilder(
        animation: _settingsController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lumen Vesper',
            theme: AppTheme.dark(),
            home: FutureBuilder<void>(
              future: _bootstrapFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _BootstrapScreen();
                }

                if (snapshot.hasError) {
                  return _BootstrapError(error: snapshot.error.toString());
                }

                return const AppShell();
              },
            ),
          );
        },
      ),
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 20),
            Text(
              'Preparando tu biblioteca local...',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BootstrapError extends StatelessWidget {
  const _BootstrapError({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text(
                'No se pudo iniciar la app.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
