import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantListHeader extends StatelessWidget {
  const ParticipantListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RTColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Name",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: RTColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "BIB Number",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: RTColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
