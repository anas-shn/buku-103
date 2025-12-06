import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.borderRadius = 12,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.primaryColor;
    final txtColor = textColor ?? Colors.white;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: bgColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _buildChild(bgColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: txtColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[500],
              ),
              child: _buildChild(txtColor),
            ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? color : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isOutlined ? color : null,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isOutlined ? color : null,
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? Colors.grey[700],
          size: size * 0.5,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
