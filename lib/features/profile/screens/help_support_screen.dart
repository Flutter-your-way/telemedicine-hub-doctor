import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Help and Support",
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildOptionBar(
                icon: Iconsax.call,
                name: 'Customer Support Contact',
                onPressed: () {
                  showContactInfoBottomSheet(context);
                }),
            SizedBox(
              height: 20.h,
            ),
            _buildOptionBar(
                icon: Iconsax.message,
                name: 'Support Chat',
                onPressed: () {
                  showContactInfoBottomSheet(context);
                }),
            SizedBox(
              height: 20.h,
            ),
            _buildOptionBar(
                icon: Iconsax.note,
                name: 'Submit Feedback',
                onPressed: () {
                  showContactInfoBottomSheet(context);
                }),
            SizedBox(
              height: 20.h,
            ),
            _buildOptionBar(
                icon: Iconsax.shield,
                name: 'Privacy Policy',
                onPressed: () {
                  showContactInfoBottomSheet(context);
                }),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOptionBar(
    {required IconData icon,
    required String name,
    required VoidCallback onPressed}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12.h),
    onTap: onPressed,
    child: Container(
      height: 56.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
            ),
            SizedBox(
              width: 18.h,
            ),
            Text(
              name,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 14.h, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            const Icon(Iconsax.arrow_right_34)
          ],
        ),
      ),
    ),
  );
}

void showContactInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 0.9],
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                _buildContactInfo(
                    Icons.phone, 'Contact Number', '+1 332 335 6767'),
                const SizedBox(height: 16),
                _buildContactInfo(
                    Icons.email_outlined, 'Email', 'hospitalname@domain.com'),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildContactInfo(IconData icon, String title, String value) {
  return Row(
    children: [
      Container(
        height: 78.h,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.h),
        decoration: BoxDecoration(
          color: Colors.green[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
      SizedBox(width: 16.h),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600))),
          Text(value,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400))),
        ],
      ),
    ],
  );
}
