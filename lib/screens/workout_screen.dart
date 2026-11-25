import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({required this.username, super.key});

  final String username;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<_WorkoutRoutine> _routines = [
    const _WorkoutRoutine(
      name: 'Lower',
      description: 'Squats, rows & leg accessories',
      exerciseCount: 6,
      durationMinutes: 45,
      icon: Icons.directions_run_rounded,
    ),
    const _WorkoutRoutine(
      name: 'Upper',
      description: 'Presses, back & shoulder work',
      exerciseCount: 7,
      durationMinutes: 50,
      icon: Icons.fitness_center_rounded,
    ),
    const _WorkoutRoutine(
      name: 'Arms',
      description: 'Focused biceps & triceps session',
      exerciseCount: 4,
      durationMinutes: 35,
      icon: Icons.bolt_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My routines',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_routines.length} saved routines',
                    style: GoogleFonts.lato(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: _createRoutine,
              icon: const Icon(Icons.add_rounded, size: 19),
              label: const Text('New routine'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_routines.isEmpty) _buildEmptyState(),
        ..._routines.map(
          (routine) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RoutineCard(
              routine: routine,
              onStart: () => _showStartSheet(routine),
              onDelete: () => _deleteRoutine(routine),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final initial = widget.username.trim().isEmpty
        ? '?'
        : widget.username.trim()[0].toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Make every session count.',
                style: GoogleFonts.lato(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: Text(
            initial,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.library_add_check_rounded,
            color: AppColors.secondaryText,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            'Create your first routine',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a training plan to get started.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createRoutine() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _CreateRoutineDialog(),
    );

    final trimmedName = name?.trim() ?? '';
    if (!mounted || trimmedName.isEmpty) return;
    setState(() {
      _routines.insert(
        0,
        _WorkoutRoutine(
          name: trimmedName,
          description: 'Add exercises to build your workout',
          exerciseCount: 0,
          durationMinutes: null,
          icon: Icons.fitness_center_rounded,
        ),
      );
    });
  }

  Future<void> _showStartSheet(_WorkoutRoutine routine) async {
    final started = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                routine.name,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                routine.exerciseCount == 0
                    ? 'This routine is ready for you to add exercises.'
                    : '${routine.exerciseCount} exercises · '
                          '${routine.durationMinutes} min estimated',
                style: GoogleFonts.lato(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start workout'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (started == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout started: ${routine.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deleteRoutine(_WorkoutRoutine routine) {
    setState(() => _routines.remove(routine));
  }
}

class _CreateRoutineDialog extends StatefulWidget {
  const _CreateRoutineDialog();

  @override
  State<_CreateRoutineDialog> createState() => _CreateRoutineDialogState();
}

class _CreateRoutineDialogState extends State<_CreateRoutineDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'New routine',
        style: GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: GoogleFonts.lato(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'e.g. Full body',
          hintStyle: GoogleFonts.lato(color: AppColors.inactiveText),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.outline),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.outline),
          ),
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.lato(color: AppColors.secondaryText),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.routine,
    required this.onStart,
    required this.onDelete,
  });

  final _WorkoutRoutine routine;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _RoutineIcon(icon: routine.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      routine.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Routine options',
                color: AppColors.surfaceAccent,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.secondaryText,
                ),
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete routine',
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _RoutineDetail(
                icon: Icons.fitness_center_rounded,
                label:
                    '${routine.exerciseCount} ${routine.exerciseCount == 1 ? 'exercise' : 'exercises'}',
              ),
              if (routine.durationMinutes != null)
                _RoutineDetail(
                  icon: Icons.schedule_rounded,
                  label: '~${routine.durationMinutes} min',
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 46,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Start routine'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineIcon extends StatelessWidget {
  const _RoutineIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: AppColors.secondaryText, size: 22),
    );
  }
}

class _RoutineDetail extends StatelessWidget {
  const _RoutineDetail({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondaryText, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.lato(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutRoutine {
  const _WorkoutRoutine({
    required this.name,
    required this.description,
    required this.exerciseCount,
    required this.durationMinutes,
    required this.icon,
  });

  final String name;
  final String description;
  final int exerciseCount;
  final int? durationMinutes;
  final IconData icon;
}
