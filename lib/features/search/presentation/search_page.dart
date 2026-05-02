import 'package:flutter/material.dart';

import '../../songs/domain/song.dart';
import '../../songs/presentation/songs_page.dart';
import '../../songs/songs_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    required this.controller,
    required this.onOpenSong,
  });

  final SongsController controller;
  final ValueChanged<Song> onOpenSong;

  @override
  Widget build(BuildContext context) {
    return SongsPage(
      controller: controller,
      onOpenSong: onOpenSong,
    );
  }
}
