import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../models/app_navigation_destination.dart';
import '../theme/app_colors.dart';

class FitnessBottomNavigationBar extends StatelessWidget {
  const FitnessBottomNavigationBar({
    required this.selectedDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final AppNavigationDestination selectedDestination;
  final ValueChanged<AppNavigationDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surfaceAccent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: AppNavigationDestination.values.map((destination) {
            final selected = destination == selectedDestination;

            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: destination.label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onDestinationSelected(destination),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          destination.icon,
                          color: selected
                              ? Colors.white
                              : AppColors.inactiveText,
                          size: 23,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          destination.label,
                          style: GoogleFonts.lato(
                            color: selected
                                ? Colors.white
                                : AppColors.inactiveText,
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
