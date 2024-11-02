import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_count_model.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/common/util/loading_view.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/notification_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_view_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 5;
  final PagingController<int, TicketModel> _pagingController =
      PagingController(firstPageKey: 1);
  int completedTickets = 0;
  int pendingTickets = 0;
  late Future<CustomResponse> _ticketCountsFuture;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _ticketCountsFuture = _fetchTicketCounts();

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
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<CustomResponse> _fetchTicketCounts() {
    return Provider.of<HomeProvider>(context, listen: false).getTicketCounts();
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
    // Refresh both the paging controller and the ticket counts
    _pagingController.refresh();
    setState(() {
      _ticketCountsFuture = _fetchTicketCounts();
    });
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
              const SliverToBoxAdapter(child: HomeAppBar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: FutureBuilder<CustomResponse>(
                    future: _ticketCountsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const StatusStatsShimmer();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data!.success) {
                        final ticketCounts =
                            snapshot.data!.data as TicketCountsModel;
                        return Row(
                          children: [
                            _buildTopViewCards(
                              ticketCounts.completed.toString(),
                              AppLocalizations.of(context)!.completedTickets,
                              () {
                                Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                    builder: (context) => TicketViewScreen(
                                        title: AppLocalizations.of(context)!
                                            .completedTickets),
                                    context: context,
                                  ),
                                );
                              },
                              context,
                            ),
                            SizedBox(width: 16.h),
                            _buildTopViewCards(
                              ticketCounts.pending.toString(),
                              AppLocalizations.of(context)!.pendingTickets,
                              () {
                                Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                    builder: (context) => TicketViewScreen(
                                        title: AppLocalizations.of(context)!
                                            .pendingTickets),
                                    context: context,
                                  ),
                                );
                              },
                              context,
                            ),
                          ],
                        );
                      } else {
                        return const Text('Failed to load ticket counts');
                      }
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.ticket,
                        style: GoogleFonts.notoSans(
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.viewAll,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoDialogRoute(
                              builder: (context) => TicketViewScreen(
                                  title:
                                      AppLocalizations.of(context)!.allTickets),
                              context: context,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: PagedSliverList<int, TicketModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<TicketModel>(
                    itemBuilder: (context, item, index) =>
                        TicketCard(ticket: item),
                    firstPageErrorIndicatorBuilder: (context) => const Center(
                      child: Text('Error loading tickets. Tap to retry.'),
                    ),
                    firstPageProgressIndicatorBuilder: (context) => Column(
                      children:
                          List.generate(3, (index) => const TicketShimmer()),
                    ),
                    newPageProgressIndicatorBuilder: (context) =>
                        const TicketShimmer(),
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

Widget noDataView(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100.h,
        ),
        Text(
          AppLocalizations.of(context)!.noTicketFound,
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp)),
        ),
        SizedBox(
          height: 40.h,
        ),
        SizedBox(
            height: 160.h,
            width: 160.w,
            child: SvgPicture.asset(AppImages.no_data)),
      ],
    ),
  );
}

Widget noDataViewForwardCase(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100.h,
        ),
        Text(
          AppLocalizations.of(context)!.noDoctorFound,
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp)),
        ),
        SizedBox(
          height: 40.h,
        ),
        SizedBox(
            height: 160.h,
            width: 160.w,
            child: SvgPicture.asset(AppImages.no_data)),
      ],
    ),
  );
}

Widget noNotificationsAvailable(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.noNotificationsAvailable,
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp)),
        ),
        SizedBox(
          height: 40.h,
        ),
        SizedBox(
            height: 160.h,
            width: 160.w,
            child: SvgPicture.asset(AppImages.no_data)),
      ],
    ),
  );
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String getGreeting(BuildContext context) {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return AppLocalizations.of(context)!.goodMorning;
      } else if (hour < 17) {
        return AppLocalizations.of(context)!.goodAfternoon;
      } else {
        return AppLocalizations.of(context)!.goodEvening;
      }
    }

    var authProvider = Provider.of<AuthProvider>(context);
    var selectedLanguage =
        Provider.of<LanguageProvider>(context, listen: false).selectedLanguage;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.captionColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(authProvider.usermodel?.name.toString() ?? '',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue,
                      )),
                  child: const Icon(
                    Iconsax.notification,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

Widget _buildTopViewCards(String value, String name,
    final VoidCallback onPressed, BuildContext context) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(12.h),
        color: Colors.white),
    child: Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
          Text(name,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400))),
          SizedBox(height: 16.h),
          Center(
            child: CupertinoButton(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(12.h),
                padding: EdgeInsets.symmetric(horizontal: 36.h),
                onPressed: onPressed,
                child: Text(AppLocalizations.of(context)!.viewAll,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600)))),
          ),
          // Container(
          //   height: 32.h,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.h),
          //       color: Colors.grey.shade300),
          //   child: const Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [Text("View")],
          //   ),
          // ),
        ],
      ),
    ),
  ));
}
