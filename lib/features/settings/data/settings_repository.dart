import '../domain/reader_settings.dart';

abstract class SettingsRepository {
  Future<ReaderSettings> load();
  Future<void> save(ReaderSettings settings);
}
