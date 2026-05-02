import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../songs_controller.dart';
import '../utils/song_text_parser.dart';
import 'song_form_page.dart';

class SongImportTxtPage extends StatefulWidget {
  const SongImportTxtPage({
    super.key,
    required this.controller,
  });

  final SongsController controller;

  @override
  State<SongImportTxtPage> createState() => _SongImportTxtPageState();
}

class _SongImportTxtPageState extends State<SongImportTxtPage> {
  String? _selectedFileName;
  bool _processing = false;

  Future<void> _pickFile() async {
    setState(() => _processing = true);

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true,
    );

    if (!mounted) return;

    if (result == null || result.files.isEmpty) {
      setState(() => _processing = false);
      return;
    }

    final file = result.files.single;
    final rawText = await _readTextFile(file);
    _selectedFileName = file.name;

    if (!mounted) return;

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SongFormPage(
          controller: widget.controller,
          initialDraft: SongTextParser.parse(rawText),
          mode: SongFormMode.importReview,
        ),
      ),
    );

    setState(() => _processing = false);

    if (changed == true && mounted) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {});
    }
  }

  Future<String> _readTextFile(PlatformFile file) async {
    if (file.bytes != null) {
      return utf8.decode(file.bytes!, allowMalformed: true);
    }
    if (file.path != null) {
      return File(file.path!).readAsString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar archivo .txt')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  Icon(Icons.description_outlined, color: AppColors.primary),
              title: Text('Importacion simple'),
              subtitle: Text(
                'Selecciona un archivo .txt. El contenido se analizara y pasara por una pantalla de revision antes de guardarse.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFileName != null)
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Archivo seleccionado'),
                subtitle: Text(_selectedFileName!),
              ),
            ),
          if (_selectedFileName != null) const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _processing ? null : _pickFile,
            icon: const Icon(Icons.upload_file),
            label: Text(
              _processing ? 'Importando...' : 'Seleccionar archivo .txt',
            ),
          ),
        ],
      ),
    );
  }
}
