import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/song.dart';
import '../domain/song_draft.dart';
import '../songs_controller.dart';

enum SongFormMode { quick, complete, importReview }

class SongFormPage extends StatefulWidget {
  const SongFormPage({
    super.key,
    required this.controller,
    this.song,
    this.initialDraft,
    this.mode = SongFormMode.complete,
  });

  final SongsController controller;
  final Song? song;
  final SongDraft? initialDraft;
  final SongFormMode mode;

  @override
  State<SongFormPage> createState() => _SongFormPageState();
}

class _SongFormPageState extends State<SongFormPage> {
  static const List<String> _toneOptions = [
    'C',
    'C#',
    'Db',
    'D',
    'D#',
    'Eb',
    'E',
    'F',
    'F#',
    'Gb',
    'G',
    'G#',
    'Ab',
    'A',
    'A#',
    'Bb',
    'B',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _lyricsController;
  late final TextEditingController _authorController;
  late final TextEditingController _categoryController;
  late final TextEditingController _genreController;
  late final TextEditingController _notesController;
  late final TextEditingController _tagsController;
  late final String? _referenceFilePath;
  late final String? _referenceFileName;
  late final String? _referenceFileType;
  late final int? _referenceFileSizeBytes;
  bool _isFavorite = false;
  bool _saving = false;
  late String _status;
  late String? _selectedTone;
  late bool _isMinorMode;
  late int _capoValue;
  late double _bpmValue;

  bool get _isEdit => widget.song != null;
  bool get _isQuick => widget.mode == SongFormMode.quick;
  bool get _isImportReview => widget.mode == SongFormMode.importReview;

  String get _pageTitle {
    if (_isEdit) {
      return 'Editar canto';
    }
    switch (widget.mode) {
      case SongFormMode.quick:
        return 'Nuevo canto rapido';
      case SongFormMode.complete:
        return 'Nuevo canto completo';
      case SongFormMode.importReview:
        return 'Revisar importacion';
    }
  }

  String get _submitLabel {
    if (_isEdit) {
      return 'Guardar cambios';
    }
    switch (widget.mode) {
      case SongFormMode.quick:
        return 'Guardar canto rapido';
      case SongFormMode.complete:
        return 'Guardar canto';
      case SongFormMode.importReview:
        return 'Confirmar importacion';
    }
  }

  @override
  void initState() {
    super.initState();
    final draft = widget.song != null
        ? SongDraft.fromSong(widget.song!)
        : (widget.initialDraft ?? const SongDraft());

    _titleController = TextEditingController(text: draft.title);
    _lyricsController = TextEditingController(text: draft.lyrics);
    _authorController = TextEditingController(text: draft.author);
    _categoryController = TextEditingController(text: draft.category);
    _genreController = TextEditingController(text: draft.genre);
    _notesController = TextEditingController(text: draft.notes);
    _tagsController = TextEditingController(text: draft.tags.join(', '));
    _referenceFilePath = draft.referenceFilePath;
    _referenceFileName = draft.referenceFileName;
    _referenceFileType = draft.referenceFileType;
    _referenceFileSizeBytes = draft.referenceFileSizeBytes;
    _status = draft.status;
    _isFavorite = widget.song?.isFavorite ?? false;

    final toneState = _parseBaseKey(draft.baseKey);
    _selectedTone = toneState.tone;
    _isMinorMode = toneState.isMinor;
    _capoValue = int.tryParse(draft.capo.trim()) ?? 0;
    _bpmValue = (draft.bpm ?? 84).clamp(40, 220).toDouble();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _lyricsController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _genreController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final lyrics = _lyricsController.text.trim();

    if (title.isEmpty && lyrics.isEmpty) {
      _showMessage('Agrega un titulo y una letra antes de guardar.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showMessage('Revisa los campos obligatorios antes de guardar.');
      return;
    }

    setState(() => _saving = true);

    final draft = SongDraft(
      title: title,
      lyrics: lyrics,
      baseKey: _composeBaseKey(),
      author: _authorController.text.trim(),
      category: _categoryController.text.trim(),
      genre: _genreController.text.trim(),
      notes: _notesController.text.trim(),
      capo: _isQuick ? '' : '$_capoValue',
      bpm: _isQuick ? null : _bpmValue.round(),
      tags: _parseTags(_tagsController.text),
      status: _status,
      referenceFilePath: _referenceFilePath,
      referenceFileName: _referenceFileName,
      referenceFileType: _referenceFileType,
      referenceFileSizeBytes: _referenceFileSizeBytes,
    );

    await widget.controller.saveDraft(
      id: widget.song?.id,
      draft: draft,
      isFavorite: _isFavorite,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  List<String> _parseTags(String value) {
    return value
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  String _composeBaseKey() {
    if (_selectedTone == null || _selectedTone!.trim().isEmpty) {
      return '';
    }
    return _isMinorMode ? '${_selectedTone!} min' : _selectedTone!;
  }

  _ToneState _parseBaseKey(String rawValue) {
    final value = rawValue.trim();
    if (value.isEmpty) {
      return const _ToneState(tone: 'C', isMinor: false);
    }

    final lower = value.toLowerCase();
    final isMinor = lower.endsWith('m') || lower.contains('min');
    final tone = _toneOptions.firstWhere(
      (option) => lower.startsWith(option.toLowerCase()),
      orElse: () => value,
    );

    return _ToneState(tone: tone, isMinor: isMinor);
  }

  Future<void> _pickTone() async {
    final selectedTone = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _toneOptions
                  .map(
                    (tone) => ChoiceChip(
                      label: Text(tone),
                      selected: tone == _selectedTone,
                      onSelected: (_) => Navigator.of(context).pop(tone),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedTone == null) {
      return;
    }

    setState(() => _selectedTone = selectedTone);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _hideKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          actions: [
            IconButton(
              tooltip: 'Ocultar teclado',
              onPressed: _hideKeyboard,
              icon: const Icon(Icons.keyboard_hide_rounded),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              if (_isImportReview) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: const Text(
                    'Revisa los campos detectados antes de guardar el canto importado.',
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titulo'),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'El titulo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 12),
              if (!_isQuick) ...[
                TextFormField(
                  controller: _authorController,
                  decoration:
                      const InputDecoration(labelText: 'Autor / artista'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
              ],
              _MusicalParametersCard(
                showExtendedControls: !_isQuick,
                selectedTone: _selectedTone ?? 'C',
                isMinorMode: _isMinorMode,
                capoValue: _capoValue,
                bpmValue: _bpmValue,
                onToneTap: _pickTone,
                onModeChanged: (value) {
                  setState(() => _isMinorMode = value);
                },
                onCapoChanged: (value) {
                  setState(() => _capoValue = value.clamp(0, 24));
                },
                onBpmChanged: (value) {
                  setState(() => _bpmValue = value);
                },
              ),
              const SizedBox(height: 16),
              if (!_isQuick) ...[
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(
                    labelText: 'Genero musical',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Etiquetas',
                    helperText: 'Separalas con comas.',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration:
                      const InputDecoration(labelText: 'Estado del canto'),
                  items: SongStatuses.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _status = value);
                  },
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: _isQuick ? 'Notas (opcional)' : 'Notas',
                ),
                minLines: 2,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lyricsController,
                decoration: const InputDecoration(
                  labelText: 'Letra',
                  helperText:
                      'Se respetan saltos de linea, espacios y separacion de estrofas.',
                ),
                minLines: _isQuick ? 8 : 12,
                maxLines: _isQuick ? 12 : 18,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'La letra es obligatoria'
                    : null,
              ),
              if (_isEdit) ...[
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _isFavorite,
                  onChanged: (value) => setState(() => _isFavorite = value),
                  title: const Text('Marcar como favorito'),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Guardando...' : _submitLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicalParametersCard extends StatelessWidget {
  const _MusicalParametersCard({
    required this.showExtendedControls,
    required this.selectedTone,
    required this.isMinorMode,
    required this.capoValue,
    required this.bpmValue,
    required this.onToneTap,
    required this.onModeChanged,
    required this.onCapoChanged,
    required this.onBpmChanged,
  });

  final bool showExtendedControls;
  final String selectedTone;
  final bool isMinorMode;
  final int capoValue;
  final double bpmValue;
  final VoidCallback onToneTap;
  final ValueChanged<bool> onModeChanged;
  final ValueChanged<int> onCapoChanged;
  final ValueChanged<double> onBpmChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            showExtendedControls ? 'Parametros Musicales' : 'Tonalidad',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Text(
            'TONALIDAD & MODO',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SelectorBox(
                  onTap: onToneTap,
                  child: Row(
                    children: [
                      Text(
                        selectedTone,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SelectorBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: _ModeButton(
                          label: 'MAJ',
                          selected: !isMinorMode,
                          onTap: () => onModeChanged(false),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: AppColors.outline,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Expanded(
                        child: _ModeButton(
                          label: 'min',
                          selected: isMinorMode,
                          onTap: () => onModeChanged(true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showExtendedControls) ...[
            const SizedBox(height: 28),
            Text(
              'CAPO TRASTE',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  _StepButton(
                    icon: Icons.remove_rounded,
                    onTap: () => onCapoChanged(capoValue - 1),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$capoValue',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _StepButton(
                    icon: Icons.add_rounded,
                    onTap: () => onCapoChanged(capoValue + 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Text(
                  'RITMO (BPM)',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bpmValue.round()}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.surface,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.18),
              ),
              child: Slider(
                min: 40,
                max: 220,
                value: bpmValue,
                onChanged: onBpmChanged,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'LENTO',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'MODERATO',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'VIVO',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectorBox extends StatelessWidget {
  const _SelectorBox({
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF353E4D),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: AppColors.primary, size: 34),
      ),
    );
  }
}

class _ToneState {
  const _ToneState({
    required this.tone,
    required this.isMinor,
  });

  final String tone;
  final bool isMinor;
}
