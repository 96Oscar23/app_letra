import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/data/shared_preferences_settings_repository.dart';
import '../../features/songs/data/sqlite_song_repository.dart';
import '../../shared/data/local_database.dart';
import 'app_dependencies.dart';

class AppBootstrap {
  static Future<AppDependencies> buildDefaultDependencies() async {
    final database = await LocalDatabase.instance.database;
    final preferences = await SharedPreferences.getInstance();

    return AppDependencies(
      songRepository: SqliteSongRepository(database),
      settingsRepository:
          SharedPreferencesSettingsRepository(preferences: preferences),
    );
  }
}
