import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../home/presentation/home_page.dart';
import '../../repertories/presentation/repertories_page.dart';
import '../../search/presentation/search_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../songs/domain/song.dart';
import '../../songs/import/import_processing_screen.dart';
import '../../songs/import/song_file_picker_service.dart';
import '../../songs/import/song_image_picker_service.dart';
import '../../songs/import/song_import_result.dart';
import '../../songs/import/song_pdf_import_service.dart';
import '../../songs/import/song_pdf_text_extractor.dart';
import '../../songs/presentation/song_creation_options_sheet.dart';
import '../../songs/presentation/song_detail_page.dart';
import '../../songs/presentation/song_form_page.dart';
import '../../songs/presentation/song_import_txt_page.dart';
import '../../songs/presentation/song_paste_text_page.dart';
import '../../songs/presentation/songs_page.dart';
import '../../songs/songs_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final SongFilePickerService _filePickerService =
      const SongFilePickerService();
  final SongPdfTextExtractor _pdfTextExtractor =
      const SongPdfTextExtractor(ReadPdfSongImportService());
  late final SongImagePickerService _imagePickerService;

  @override
  void initState() {
    super.initState();
    _imagePickerService = SongImagePickerService();
  }

  Future<void> _openCreateSong(BuildContext context) async {
    final songsController = AppScope.of(context).songsController;
    final action = await showModalBottomSheet<SongCreationAction>(
      context: context,
      backgroundColor: const Color(0xFF1B2431),
      barrierColor: Colors.black.withValues(alpha: 0.55),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      isScrollControlled: true,
      builder: (_) => const SongCreationOptionsSheet(),
    );

    if (!context.mounted || action == null) {
      return;
    }

    bool? changed;

    switch (action) {
      case SongCreationAction.quick:
        changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => SongFormPage(
              controller: songsController,
              mode: SongFormMode.quick,
            ),
          ),
        );
        break;
      case SongCreationAction.complete:
        changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => SongFormPage(
              controller: songsController,
              mode: SongFormMode.complete,
            ),
          ),
        );
        break;
      case SongCreationAction.pasteText:
        changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => SongPasteTextPage(controller: songsController),
          ),
        );
        break;
      case SongCreationAction.importTxt:
        changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => SongImportTxtPage(controller: songsController),
          ),
        );
        break;
      case SongCreationAction.importPdf:
        changed = await _openPdfImportFlow(
          context,
          loader: _filePickerService.pickPdf,
          retryActionLabel: 'Seleccionar otro PDF',
        );
        break;
      case SongCreationAction.importImage:
        changed = await _openImageImportFlow(
          context,
          loader: _imagePickerService.pickFromGallery,
          retryActionLabel: 'Seleccionar otra imagen',
        );
        break;
      case SongCreationAction.takePhoto:
        changed = await _openImageImportFlow(
          context,
          loader: _imagePickerService.takePhoto,
          retryActionLabel: 'Tomar otra foto',
        );
        break;
    }

    if (changed == true) {
      await songsController.loadSongs();
    }
  }

  Future<bool?> _openImageImportFlow(
    BuildContext context, {
    required Future<SongImportResult?> Function() loader,
    required String retryActionLabel,
  }) async {
    final songsController = AppScope.of(context).songsController;

    try {
      final result = await loader();
      if (!context.mounted) {
        return null;
      }

      if (result == null) {
        _showMessage(context, 'Seleccion cancelada.');
        return false;
      }

      return Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ImportProcessingScreen.forImage(
            controller: songsController,
            initialImportResult: result,
            retryLoader: loader,
            retryActionLabel: retryActionLabel,
          ),
        ),
      );
    } on SongImportException catch (error) {
      if (context.mounted) {
        _showMessage(context, error.message);
      }
      return false;
    } catch (_) {
      if (context.mounted) {
        _showMessage(
          context,
          'No se pudo abrir el flujo de OCR para la imagen seleccionada.',
        );
      }
      return false;
    }
  }

  Future<bool?> _openPdfImportFlow(
    BuildContext context, {
    required Future<SongImportResult?> Function() loader,
    required String retryActionLabel,
  }) async {
    final songsController = AppScope.of(context).songsController;

    try {
      final result = await loader();
      if (!context.mounted) {
        return null;
      }

      if (result == null) {
        _showMessage(context, 'Seleccion cancelada.');
        return false;
      }

      return Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ImportProcessingScreen(
            controller: songsController,
            initialImportResult: result,
            retryLoader: loader,
            retryActionLabel: retryActionLabel,
            initialStatusLabel: 'Extrayendo texto del PDF...',
            noTextTitle: 'No se pudo extraer texto de este PDF',
            noTextMessage:
                'Este PDF puede estar escaneado o no contener texto seleccionable. Prueba con otro PDF, pega texto o continua a la revision manual.',
            errorTitle: 'No se pudo procesar el PDF',
            fallbackErrorMessage:
                'Ocurrio un problema al leer el PDF seleccionado.',
            retrySelectionErrorMessage:
                'No se pudo volver a cargar el PDF seleccionado.',
            processor: (
              SongImportResult importResult, {
              void Function(String status)? onStatusChanged,
            }) async {
              onStatusChanged?.call('Extrayendo texto del PDF...');
              final extraction =
                  await _pdfTextExtractor.extractText(importResult);
              return SongImportProcessingPayload(
                initialDraft: extraction.initialDraft,
                helperMessage:
                    'Se detecto texto en el PDF. Revisa y corrige antes de guardar.',
              );
            },
          ),
        ),
      );
    } on SongImportException catch (error) {
      if (context.mounted) {
        _showMessage(context, error.message);
      }
      return false;
    } catch (_) {
      if (context.mounted) {
        _showMessage(
          context,
          'No se pudo abrir el flujo de importacion del PDF.',
        );
      }
      return false;
    }
  }

  Future<void> _openSongDetail(BuildContext context, Song song) async {
    final scope = AppScope.of(context);
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SongDetailPage(
          songId: song.id!,
          songsController: scope.songsController,
          settingsController: scope.settingsController,
        ),
      ),
    );
    if (changed == true) {
      await scope.songsController.loadSongs();
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);

    return AnimatedBuilder(
      animation: scope.songsController,
      builder: (context, _) {
        final pages = [
          HomePage(
            songCount: scope.songsController.songs.length,
            favoriteCount: scope.songsController.songs
                .where((song) => song.isFavorite)
                .length,
            onOpenSongs: () => setState(() => _currentIndex = 1),
            onOpenFavorites: () async {
              setState(() => _currentIndex = 1);
              await scope.songsController.setFilter(SongFilter.favorites);
            },
            onOpenSettings: () => setState(() => _currentIndex = 4),
            onOpenSearch: () => setState(() => _currentIndex = 3),
          ),
          SongsPage(
            controller: scope.songsController,
            onOpenSong: (song) => _openSongDetail(context, song),
          ),
          const RepertoriesPage(),
          SearchPage(
            controller: scope.songsController,
            onOpenSong: (song) => _openSongDetail(context, song),
          ),
          SettingsPage(controller: scope.settingsController),
        ];

        final titles = [
          'Inicio',
          'Canciones',
          'Repertorios',
          'Buscar',
          'Configuracion',
        ];

        final wide = MediaQuery.of(context).size.width >= 920;

        return Scaffold(
          appBar: AppBar(title: Text(titles[_currentIndex])),
          body: wide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (value) {
                        setState(() => _currentIndex = value);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Inicio'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.library_music_outlined),
                          selectedIcon: Icon(Icons.library_music),
                          label: Text('Canciones'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.queue_music_outlined),
                          selectedIcon: Icon(Icons.queue_music),
                          label: Text('Repertorios'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.search),
                          selectedIcon: Icon(Icons.search),
                          label: Text('Buscar'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Ajustes'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: pages[_currentIndex]),
                  ],
                )
              : pages[_currentIndex],
          floatingActionButton: _currentIndex == 1 || _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => _openCreateSong(context),
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (value) {
                    setState(() => _currentIndex = value);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Inicio',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.library_music_outlined),
                      selectedIcon: Icon(Icons.library_music),
                      label: 'Canciones',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.queue_music_outlined),
                      selectedIcon: Icon(Icons.queue_music),
                      label: 'Repertorios',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search),
                      selectedIcon: Icon(Icons.search),
                      label: 'Buscar',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: 'Ajustes',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
