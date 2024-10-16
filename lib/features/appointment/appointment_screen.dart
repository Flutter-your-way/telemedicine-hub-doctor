import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/common/util/loading_view.dart';
import 'package:telemedicine_hub_doctor/features/appointment/provider/appointment_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        body: Column(
          children: [
            const HomeAppBar(),
            Expanded(
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
          ],
        ),
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
  static const _pageSize = 5;
  final PagingController<int, TicketModel> _pagingController =
      PagingController(firstPageKey: 1);
  int completedTickets = 0;
  int pendingTickets = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getTickets(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      // _updateTicketCounts();
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<TicketModel>> getTickets(int pageKey) async {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    var res = await homeProvider.getTickets(
      doctorId: authProvider.usermodel!.id.toString(),
      status: '',
      page: pageKey,
      limit: _pageSize,
    );

    if (res.success) {
      return res.data['tickets'];
    } else {
      throw Exception(res.msg ?? 'Failed to fetch tickets');
    }
  }

  Future<void> _refreshData() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: PagedSliverList<int, TicketModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<TicketModel>(
                    itemBuilder: (context, item, index) =>
                        TicketCard(ticket: item),
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Text('Error loading tickets. Tap to retry.'),
                    ),
                    firstPageProgressIndicatorBuilder: (context) => Column(
                      children: List.generate(3, (index) => TicketShimmer()),
                    ),
                    newPageProgressIndicatorBuilder: (context) =>
                        TicketShimmer(),
                    noItemsFoundIndicatorBuilder: (context) =>
                        noDataView(context),
                  ),
                ),
              )
            ],
          ),
        ),
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
                  child: TicketShimmer(),
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
