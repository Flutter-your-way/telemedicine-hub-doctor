// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class TicketViewScreen extends StatefulWidget {
  String title;
  String? value;
  TicketViewScreen({
    super.key,
    required this.title,
    this.value,
  });

  @override
  State<TicketViewScreen> createState() => _TicketViewScreenState();
}

class _TicketViewScreenState extends State<TicketViewScreen> {
  List<TicketModel> ticketList = [];
  List<TicketModel> filteredTicketList = [];
  String status = '';
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();

  //   getTickets();
  // }

  static const _pageSize = 5;
  final PagingController<int, TicketModel> _pagingController =
      PagingController(firstPageKey: 1);
  int completedTickets = 0;
  int pendingTickets = 0;

  @override
  void initState() {
    if (widget.title == "Completed Tickets") {
      status = 'completed';
    } else if (widget.title == "Pending Tickets") {
      status = 'pending';
    } else {
      status = '';
    }

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  String searchQuery = '';

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getTickets(pageKey, status, searchQuery);
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

  Future<List<TicketModel>> getTickets(int pageKey, String status,
      [String search = '']) async {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var res = await homeProvider.getTickets(
      doctorId: authProvider.usermodel!.id.toString(),
      status: status,
      search: search,
      page: pageKey,
      limit: _pageSize,
    );

    if (res.success) {
      return res.data['tickets'];
    } else {
      throw Exception(res.msg);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _pagingController.refresh(); // Refresh the list with new search query
    });
  }

  Future<void> _refreshData() async {
    // Refresh both the paging controller and the ticket counts
    _pagingController.refresh();
    // setState(() {
    //   _ticketCountsFuture = _fetchTicketCounts();
    // });
  }

  // void _onSearchChanged(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredTicketList = ticketList;
  //     } else {
  //       filteredTicketList = ticketList.where((ticket) {
  //         return ticket.name!.toLowerCase().contains(query.toLowerCase()) ||
  //             ticket.disease!.name!
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             ticket.patient!.name!.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

  List<String> sortList = [
    'sort by latest',
    'sort by oldest',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            widget.title,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          ),
          centerTitle: false,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SearchField(
                    function: (value) {
                      setState(() {
                        _onSearchChanged(value);
                      });
                    },
                    sortList: sortList,
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
}

class SearchField extends StatelessWidget {
  List<String> sortList;
  void Function(String)? function;
  SearchField({
    super.key,
    required this.sortList,
    this.function,
  });

  bool hasSpecialCharacters(String input) {
    final RegExp allowedPattern = RegExp(r'^[a-zA-Z0-9\s]*$');
    return !allowedPattern.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (!hasSpecialCharacters(value)) {
          function?.call(value);
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.w),
        hintText: AppLocalizations.of(context)!.searchForTickets,
        prefixIcon: const Icon(Iconsax.search_normal),
        hintStyle: TextStyle(
          color: AppColors.captionColor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.captionColor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.captionColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.captionColor),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

void showSortBottomSheet(BuildContext context, List<String> sortList) {
  List<String> selectedList = [];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 0.95],
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDragHandle(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildSortList(
                          sortList, selectedList, setState, scrollController),
                    ),
                    const SizedBox(height: 16),
                    _buildSortButton(context),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget _buildDragHandle() {
  return Container(
    width: 32,
    height: 4,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF79747E),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

Widget _buildSortList(List<String> sortList, List<String> selectedList,
    StateSetter setState, ScrollController scrollController) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    controller: scrollController,
    itemCount: sortList.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            onTap: () {
              setState(() {
                if (selectedList.contains(sortList[index])) {
                  selectedList.remove(sortList[index]);
                } else {
                  selectedList.add(sortList[index]);
                }
              });
            },
            horizontalTitleGap: 24,
            leading: _buildCheckbox(selectedList.contains(sortList[index])),
            title: Text(
              sortList[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildCheckbox(bool isSelected) {
  return Container(
    height: 24,
    width: 24,
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? AppColors.blue : const Color(0xFFD9D9D9),
        width: 2,
      ),
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.blue : Colors.transparent,
        ),
      ),
    ),
  );
}

Widget _buildSortButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        // Handle sort action
        Navigator.pop(context);
      },
      child: const Text(
        "Sort",
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}
