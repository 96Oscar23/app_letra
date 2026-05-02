import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../songs_controller.dart';
import '../utils/song_text_parser.dart';
import 'song_form_page.dart';

class SongPasteTextPage extends StatefulWidget {
  const SongPasteTextPage({
    super.key,
    required this.controller,
  });

  final SongsController controller;

  @override
  State<SongPasteTextPage> createState() => _SongPasteTextPageState();
}

class _SongPasteTextPageState extends State<SongPasteTextPage> {
  late final TextEditingController _textController;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    _textController.text = data?.text ?? '';
  }

  Future<void> _continueToReview() async {
    final rawText = _textController.text;
    if (rawText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pega un texto antes de continuar.'),
        ),
      );
      return;
    }

    setState(() => _processing = true);
    final draft = SongTextParser.parse(rawText);
    if (!mounted) return;

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SongFormPage(
          controller: widget.controller,
          initialDraft: draft,
          mode: SongFormMode.importReview,
        ),
      ),
    );

    setState(() => _processing = false);

    if (changed == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pegar texto')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Pega texto largo respetando saltos de linea, espacios y separacion de estrofas.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            minLines: 14,
            maxLines: 22,
            decoration: const InputDecoration(
              labelText: 'Texto del canto',
              hintText:
                  'Titulo: ...\nAutor: ...\nTono: ...\n\nPega aqui la letra completa...',
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pasteFromClipboard,
            icon: const Icon(Icons.content_paste_go),
            label: const Text('Pegar desde portapapeles'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _processing ? null : _continueToReview,
            icon: const Icon(Icons.arrow_forward),
            label: Text(_processing ? 'Procesando...' : 'Continuar a revision'),
          ),
        ],
      ),
    );
  }
}
