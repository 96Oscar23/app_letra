import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reader_settings.dart';
import 'settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const _fontScaleKey = 'reader_font_scale';
  static const _showChordsKey = 'reader_show_chords';
  static const _keepScreenAwakeKey = 'reader_keep_screen_awake';

  @override
  Future<ReaderSettings> load() async {
    return ReaderSettings(
      fontScale: _preferences.getDouble(_fontScaleKey) ?? 1,
      showChords: _preferences.getBool(_showChordsKey) ?? true,
      keepScreenAwake: _preferences.getBool(_keepScreenAwakeKey) ?? false,
    );
  }

  @override
  Future<void> save(ReaderSettings settings) async {
    await _preferences.setDouble(_fontScaleKey, settings.fontScale);
    await _preferences.setBool(_showChordsKey, settings.showChords);
    await _preferences.setBool(
      _keepScreenAwakeKey,
      settings.keepScreenAwake,
    );
  }
}
