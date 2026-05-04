import 'package:flutter/material.dart';

import '../../songs/domain/song.dart';
import '../../songs/presentation/songs_page.dart';
import '../../songs/songs_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    required this.controller,
    required this.onOpenSong,
    required this.onEditSong,
  });

  final SongsController controller;
  final ValueChanged<Song> onOpenSong;
  final Future<bool?> Function(Song song) onEditSong;

  @override
  Widget build(BuildContext context) {
    return SongsPage(
      controller: controller,
      onOpenSong: onOpenSong,
      onEditSong: onEditSong,
    );
  }
}
