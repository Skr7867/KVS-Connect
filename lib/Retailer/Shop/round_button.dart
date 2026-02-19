import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/colors.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    this.buttonColor = AppColors.textWhite,
    this.textColor = AppColors.blackColor,
    required this.title,
    this.onPress,
    this.width = 150,
    this.height = 50,
    this.loading = false,
    this.fontSize = 15,
  });

  final bool loading;
  final String title;
  final double height, width;
  final VoidCallback? onPress;
  final Color textColor;
  final Color buttonColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPress == null || loading;
    return InkWell(
      onTap: isDisabled ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border(),
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.textWhite),
              )
            : Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
      ),
    );
  }
}
