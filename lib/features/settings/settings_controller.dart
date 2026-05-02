import 'package:flutter/foundation.dart';

import 'data/settings_repository.dart';
import 'domain/reader_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  ReaderSettings _settings = ReaderSettings.defaults();

  ReaderSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _repository.load();
    notifyListeners();
  }

  Future<void> setFontScale(double value) async {
    final normalized = value.clamp(0.85, 1.6);
    _settings = _settings.copyWith(fontScale: normalized);
    notifyListeners();
    await _repository.save(_settings);
  }

  Future<void> toggleShowChords(bool value) async {
    _settings = _settings.copyWith(showChords: value);
    notifyListeners();
    await _repository.save(_settings);
  }

  Future<void> toggleKeepScreenAwake(bool value) async {
    _settings = _settings.copyWith(keepScreenAwake: value);
    notifyListeners();
    await _repository.save(_settings);
  }
}
