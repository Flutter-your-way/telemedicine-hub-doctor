import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  var pages = [

    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
            // top: 20,
          ),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomItem(
                  icon: Iconsax.home_2,
                  selected: selectedIndex == 0,
                  onTap: () {
                    if (selectedIndex != 0) {
                      setState(() {
                        selectedIndex = 0;
                      });
                    }
                  },
                ),
                _bottomItem(
                  icon: Iconsax.calendar_1,
                  selected: selectedIndex == 1,
                  onTap: () {
                    if (selectedIndex != 1) {
                      setState(() {
                        selectedIndex = 1;
                      });
                    }
                  },
                ),
                _bottomItem(
                  icon: Iconsax.user_octagon,
                  selected: selectedIndex == 2,
                  onTap: () {
                    if (selectedIndex != 2) {
                      setState(() {
                        selectedIndex = 2;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 95,
      width: 95,
      child: CupertinoButton(
        onPressed: selected
            ? null
            : () {
                onTap();
              },
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: AnimatedScale(
            //     scale: selected ? 1 : 0,
            //     duration: const Duration(milliseconds: 400),
            //     curve: Curves.fastEaseInToSlowEaseOut,
            //     child: AnimatedRotation(
            //       turns: selected ? 0 : .15,
            //       duration: const Duration(milliseconds: 400),
            //       curve: Curves.fastEaseInToSlowEaseOut,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: !selected
            //               ? null
            //               : AppColors.primaryBlue.withOpacity(.4),
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: !selected
            //               ? null
            //               : [
            //                   BoxShadow(
            //                     color: AppColors.primaryBlue,
            //                     blurRadius: 20,
            //                     offset: const Offset(0, 8),
            //                   ),
            //                 ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: selected
                    ? AppColors.primaryBlue
                    : Colors.grey.withOpacity(.8),
                size: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}
