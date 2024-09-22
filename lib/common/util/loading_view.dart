// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoaderView extends StatefulWidget {
  double? height;
  double? width;
  LoaderView({
    super.key,
    this.height = 28,
    this.width = 28,
  });

  @override
  State<LoaderView> createState() => _LoaderViewState();
}

class _LoaderViewState extends State<LoaderView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width?.h,
      height: widget.height?.w,
      child: Center(
          child: Platform.isAndroid
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : const CupertinoActivityIndicator(
                  color: Colors.black,
                )),
    );
  }
}
