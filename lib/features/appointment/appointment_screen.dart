import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    snap: true,
                    expandedHeight: 0.0,
                    floating: true,
                    pinned: true,
                    primary: false,
                    bottom: TabBar(
                      padding: EdgeInsets.zero,
                      controller: controller,
                      indicatorColor: AppColors.primaryBlue,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Colors.black)),
                      labelStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColors.primaryBlue)),
                      dividerHeight: 0,
                      tabs: const [
                        Tab(text: 'Recent Tickets'),
                        Tab(text: 'Forwarded Cases'),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: controller,
                      children: const <Widget>[
                        RecentTapView(),
                        ForwardedCasesView()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RecentTapView extends StatefulWidget {
  const RecentTapView({super.key});

  @override
  State<RecentTapView> createState() => _RecentTapViewState();
}

class _RecentTapViewState extends State<RecentTapView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const TicketCard();
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

class ForwardedCasesView extends StatefulWidget {
  const ForwardedCasesView({super.key});

  @override
  State<ForwardedCasesView> createState() => _ForwardedCasesViewState();
}

class _ForwardedCasesViewState extends State<ForwardedCasesView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const TicketCard();
            },
          ),
          SizedBox(
            height: MediaQuery.paddingOf(context).bottom,
          ),
        ],
      ),
    );
  }
}
