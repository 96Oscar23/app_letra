import '../../features/settings/data/settings_repository.dart';
import '../../features/songs/data/song_repository.dart';

class AppDependencies {
  const AppDependencies({
    required this.songRepository,
    required this.settingsRepository,
  });

  final SongRepository songRepository;
  final SettingsRepository settingsRepository;
}
