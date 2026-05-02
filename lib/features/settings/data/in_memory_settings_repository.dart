import '../domain/reader_settings.dart';
import 'settings_repository.dart';

class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository({
    ReaderSettings? initial,
  }) : _settings = initial ?? ReaderSettings.defaults();

  ReaderSettings _settings;

  @override
  Future<ReaderSettings> load() async => _settings;

  @override
  Future<void> save(ReaderSettings settings) async {
    _settings = settings;
  }
}
