import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:telemedicine_hub_doctor/common/button/custom_button.dart';

const Color grayColor = Color(0xFF8D8D8E);

const double defaultPadding = 16.0;

class ImagesShimmer extends StatelessWidget {
  const ImagesShimmer({Key? key, this.childd}) : super(key: key);
  final Widget? childd;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 0, 0, 0),
      highlightColor: Colors.grey[300]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: childd,
                height: 100,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding))),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusStatsShimmer extends StatelessWidget {
  const StatusStatsShimmer({Key? key, this.childd}) : super(key: key);
  final Widget? childd;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 48) / 2; // Subtracting 48 for padding (16 * 3)

    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 0, 0, 0),
      highlightColor: Colors.grey[300]!,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: childd,
              height: 130.h,
              width: 150.w,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              child: childd,
              height: 130.h,
              width: 150.w,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketShimmer extends StatelessWidget {
  const TicketShimmer({Key? key, this.childd}) : super(key: key);
  final Widget? childd;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 0, 0, 0),
      highlightColor: Colors.grey[300]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: childd,
                height: 150,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding))),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: childd,
                height: 150,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding))),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: childd,
                height: 150,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding))),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: childd,
                height: 150,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding))),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
