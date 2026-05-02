class ReaderSettings {
  const ReaderSettings({
    required this.fontScale,
    required this.showChords,
    required this.keepScreenAwake,
  });

  factory ReaderSettings.defaults() {
    return const ReaderSettings(
      fontScale: 1,
      showChords: true,
      keepScreenAwake: false,
    );
  }

  final double fontScale;
  final bool showChords;
  final bool keepScreenAwake;

  ReaderSettings copyWith({
    double? fontScale,
    bool? showChords,
    bool? keepScreenAwake,
  }) {
    return ReaderSettings(
      fontScale: fontScale ?? this.fontScale,
      showChords: showChords ?? this.showChords,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
    );
  }
}
