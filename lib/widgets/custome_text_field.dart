import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeemilocker/text_style/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final IconData? passwordVisibleIcon;
  final IconData? passwordInvisibleIcon;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Color? fillColor;
  final Color? textColor;
  final double? fontSize;
  final Color? hintTextColor;
  final Color? borderColor;
  final double borderRadius;
  final int maxLength;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.fontSize,
    this.readOnly,
    this.labelText,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.passwordVisibleIcon,
    this.passwordInvisibleIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.textColor,
    this.hintTextColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.maxLength = 1000,
    this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.height,
    this.inputFormatters,
    this.enabled = true,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 45,
      child: TextFormField(
        enabled: widget.enabled,
        cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
        cursorHeight: 20,
        obscureText: widget.isPassword ? !_isPasswordVisible : false,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        controller: widget.controller,
        maxLines: widget.maxLines ?? 1,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        readOnly: widget.readOnly ?? false,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.height != null ? widget.height! / 3 : 12.0,
            horizontal: 15,
          ),
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: AppColors.textColor)
              : null,

          // Dynamic suffixIcon
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? (widget.passwordVisibleIcon ?? Icons.visibility_sharp)
                        : (widget.passwordInvisibleIcon ??
                              Icons.visibility_off),
                    color: AppColors.textColor,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : widget.suffixIcon,

          // filled: widget.fillColor != null,
          fillColor: widget.enabled
              ? (widget.fillColor ?? Colors.white)
              : AppColors.greyColor.withOpacity(0.1),
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? AppColors.textColor,

            fontSize: 15,
          ),
          labelStyle: TextStyle(color: widget.textColor ?? Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.greyColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          counterText: '',
        ),
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
}
