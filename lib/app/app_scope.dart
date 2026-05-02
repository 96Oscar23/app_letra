import 'package:flutter/widgets.dart';

import '../features/settings/settings_controller.dart';
import '../features/songs/songs_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.songsController,
    required this.settingsController,
    required super.child,
  });

  final SongsController songsController;
  final SettingsController settingsController;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope no encontrado en el contexto.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return songsController != oldWidget.songsController ||
        settingsController != oldWidget.settingsController;
  }
}
