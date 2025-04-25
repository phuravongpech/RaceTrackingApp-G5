import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

enum RtButtonType { primary, secondary, disabled }

class RtButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final RtButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const RtButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = RtButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == RtButtonType.primary;
    final isDisabled = type == RtButtonType.disabled;

    return SizedBox(
      width: fullWidth ? double.infinity : 200,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisabled
                  ? RTColors.textSecondary.withOpacity(0.5)
                  : isPrimary
                  ? RTColors.primary
                  : RTColors.white,
          foregroundColor:
              isDisabled
                  ? RTColors.white
                  : isPrimary
                  ? RTColors.white
                  : RTColors.primary,
          disabledBackgroundColor: RTColors.textSecondary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                isPrimary || isDisabled
                    ? BorderSide.none
                    : const BorderSide(color: RTColors.primary),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(RTColors.white),
        ),
      );
    }

    final textColor =
        type == RtButtonType.disabled
            ? RTColors.white
            : type == RtButtonType.primary
            ? RTColors.white
            : RTColors.primary;

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: RTTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: RTTextStyles.body.copyWith(
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
    );
  }
}
