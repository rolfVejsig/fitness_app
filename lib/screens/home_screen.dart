import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../models/app_navigation_destination.dart';
import '../theme/app_colors.dart';
import '../view_models/home_view_model.dart';
import '../widgets/dashboard_section_card.dart';
import '../widgets/fitness_bottom_navigation_bar.dart';
import 'login_screen.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.username, super.key});

  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(username: widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: IndexedStack(
              index:
                  _viewModel.selectedDestination ==
                      AppNavigationDestination.workouts
                  ? 1
                  : 0,
              children: [
                _buildDashboard(context),
                WorkoutScreen(username: _viewModel.username),
              ],
            ),
          ),
          bottomNavigationBar: FitnessBottomNavigationBar(
            selectedDestination: _viewModel.selectedDestination,
            onDestinationSelected: _viewModel.selectDestination,
          ),
        );
      },
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          const DashboardSectionCard(
            title: 'Activity',
            icon: Icons.insights_rounded,
            message: 'No activity recorded yet',
            height: 190,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: DashboardSectionCard(
                  title: 'Steps',
                  icon: Icons.directions_walk_rounded,
                  message: 'No step data yet',
                  height: 150,
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: DashboardSectionCard(
                  title: 'Workouts',
                  icon: Icons.fitness_center_rounded,
                  message: 'No workouts yet',
                  height: 150,
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const DashboardSectionCard(
            title: 'Progression',
            icon: Icons.trending_up_rounded,
            message: 'Your progress will appear here',
            height: 154,
            compact: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _viewModel.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your fitness dashboard',
                style: GoogleFonts.lato(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: IconButton(
            tooltip: 'Log out',
            onPressed: () => _logOut(context),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _logOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
