// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class CustomOutlineButton extends StatelessWidget {
  final String icon;
  final String text;
  final Function()? onPressed;
  final Color borderColor;

  CustomOutlineButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onPressed,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10000),
          border: Border.all(
            color: borderColor, // Border color
            width: 0.8, // Border width
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onTap: onPressed,
          leading: SvgPicture.asset(
            icon,
            height: 20.h,
            width: 20.w,
          ),
          title: Text(
            "      ${text}",
            style: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
