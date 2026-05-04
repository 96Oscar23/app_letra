import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/song_tag.dart';
import '../songs_controller.dart';

class SongTagsPage extends StatefulWidget {
  const SongTagsPage({
    super.key,
    required this.controller,
    required this.songId,
    required this.songTitle,
  });

  final SongsController controller;
  final int songId;
  final String songTitle;

  @override
  State<SongTagsPage> createState() => _SongTagsPageState();
}

class _SongTagsPageState extends State<SongTagsPage> {
  final TextEditingController _newTagController = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  List<SongTag> _allTags = const [];
  Set<int> _selectedTagIds = const {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  List<SongTag> get _selectedTags => _allTags
      .where((tag) => tag.id != null && _selectedTagIds.contains(tag.id))
      .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  List<SongTag> get _customTags =>
      _allTags.where((tag) => tag.isCustom).toList(growable: false);

  List<SongTag> get _seasonEventTags =>
      _allTags.where((tag) => tag.isSeasonEvent).toList(growable: false);

  Future<void> _loadData() async {
    final allTags = widget.controller.tags.isNotEmpty
        ? widget.controller.tags
        : await widget.controller.refreshTags();
    final selectedTags = await widget.controller.tagsForSong(widget.songId);
    if (!mounted) {
      return;
    }
    setState(() {
      _allTags = allTags;
      _selectedTagIds =
          selectedTags.map((tag) => tag.id).whereType<int>().toSet();
      _loading = false;
    });
  }

  Future<void> _addTag() async {
    final name = _newTagController.text.trim();
    if (name.isEmpty) {
      _showMessage('Escribe un nombre para la etiqueta.');
      return;
    }

    try {
      final created = await widget.controller.createTag(name);
      if (!mounted) {
        return;
      }
      setState(() {
        _allTags = widget.controller.tags;
        if (created.id != null) {
          _selectedTagIds = {..._selectedTagIds, created.id!};
        }
        _newTagController.clear();
      });
    } on StateError catch (error) {
      _showMessage(error.message);
    }
  }

  Future<void> _renameTag(SongTag tag) async {
    final controller = TextEditingController(text: tag.name);
    final nextName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar etiqueta'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nextName == null || nextName.trim().isEmpty || nextName == tag.name) {
      return;
    }

    try {
      await widget.controller.renameTag(tag, nextName);
      if (!mounted) {
        return;
      }
      setState(() {
        _allTags = widget.controller.tags;
      });
    } on StateError catch (error) {
      _showMessage(error.message);
    }
  }

  Future<void> _deleteTag(SongTag tag) async {
    final assignedSomewhere = tag.usageCount > 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar etiqueta'),
        content: Text(
          assignedSomewhere
              ? 'La etiqueta "${tag.name}" esta asignada a ${tag.usageCount} canto(s). Se quitaran esas relaciones, pero no se borrara ningun canto.'
              : 'La etiqueta "${tag.name}" se eliminara de forma permanente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await widget.controller.deleteTag(tag);
    if (!mounted) {
      return;
    }
    setState(() {
      _allTags = widget.controller.tags;
      if (tag.id != null) {
        _selectedTagIds = {..._selectedTagIds}..remove(tag.id);
      }
    });
  }

  void _toggleTag(SongTag tag) {
    if (tag.id == null) {
      return;
    }
    setState(() {
      final next = {..._selectedTagIds};
      if (next.contains(tag.id)) {
        next.remove(tag.id);
      } else {
        next.add(tag.id!);
      }
      _selectedTagIds = next;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.controller.setSongTags(widget.songId, _selectedTags);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Etiquetas')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organiza tus cantos con etiquetas personalizadas.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newTagController,
                      decoration: InputDecoration(
                        labelText: 'Nueva etiqueta',
                        suffixIcon: IconButton(
                          onPressed: _addTag,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _addTag(),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _SectionCard(
                            title: 'Personalizadas',
                            child: _EditableTagWrap(
                              tags: _customTags,
                              selectedIds: _selectedTagIds,
                              onToggle: _toggleTag,
                              onEdit: _renameTag,
                              onDelete: _deleteTag,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Temporada / evento',
                            child: _EditableTagWrap(
                              tags: _seasonEventTags,
                              selectedIds: _selectedTagIds,
                              onToggle: _toggleTag,
                              onEdit: _renameTag,
                              onDelete: _deleteTag,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Asignadas a este canto',
                            subtitle: widget.songTitle,
                            child: _selectedTags.isEmpty
                                ? const Text(
                                    'Todavia no hay etiquetas asignadas.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  )
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _selectedTags
                                        .map(
                                          (tag) => InputChip(
                                            label: Text(tag.name),
                                            selected: true,
                                            onDeleted: () => _toggleTag(tag),
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _saving ? null : _save,
                        child: Text(_saving ? 'Guardando...' : 'Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EditableTagWrap extends StatelessWidget {
  const _EditableTagWrap({
    required this.tags,
    required this.selectedIds,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SongTag> tags;
  final Set<int> selectedIds;
  final ValueChanged<SongTag> onToggle;
  final ValueChanged<SongTag> onEdit;
  final ValueChanged<SongTag> onDelete;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const Text(
        'No hay etiquetas disponibles todavia.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final selected = tag.id != null && selectedIds.contains(tag.id);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.18)
                : AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => onToggle(tag),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    tag.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onEdit(tag),
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => onDelete(tag),
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
