import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/util/loading_view.dart';
import 'package:telemedicine_hub_doctor/features/appointment/provider/appointment_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    backgroundColor: AppColors.bluishWhite,
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
                      tabs: [
                        Tab(text: AppLocalizations.of(context)!.recentTickets),
                        Tab(text: AppLocalizations.of(context)!.forwardedCases),
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
  List<TicketModel> ticketList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getTickets();
      },
    );
    super.initState();
  }

  void getTickets() async {
    try {
      var res = await Provider.of<AppointmentProvider>(context, listen: false)
          .getRecentTickets(
              doctorId: Provider.of<AuthProvider>(context, listen: false)
                  .usermodel!
                  .id
                  .toString());
      if (res.success) {
        if (mounted) {
          setState(() {
            // ticketList = res.data
            //   ..sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
            ticketList = res.data
              ..removeWhere((ticket) => ticket.scheduleDate == null);
            ticketList
                .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
          });
        }
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Provider.of<HomeProvider>(context).isLoading
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.3),
                  child: LoaderView(),
                )
              : ticketList.isEmpty
                  ? noDataView(context)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ticketList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = ticketList[index];
                        return TicketCard(ticket: data);
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
  List<TicketModel> ticketList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getTickets();
      },
    );
    super.initState();
  }

  void getTickets() async {
    try {
      var res = await Provider.of<AppointmentProvider>(context, listen: false)
          .getForwardedTickets(
              doctorId: Provider.of<AuthProvider>(context, listen: false)
                  .usermodel!
                  .id
                  .toString());
      if (res.success) {
        if (mounted) {
          setState(() {
            ticketList = res.data;
          });
        }
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Provider.of<HomeProvider>(context).isLoading
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.3),
                  child: LoaderView(),
                )
              : ticketList.isEmpty
                  ? noDataView(context)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ticketList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = ticketList[index];
                        return TicketCard(ticket: data);
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
