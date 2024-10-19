// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/common/util/loading_view.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class TicketViewScreen extends StatefulWidget {
  String title;
  TicketViewScreen({
    super.key,
    required this.title,
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

  @override
  void initState() {
    super.initState();
    if (widget.title == "Completed Ticket") {
      status = 'completed';
    } else if (widget.title == "Pending Ticket") {
      status = 'pending';
    } else {
      status = '';
    }
    getTickets();
  }

  Future<void> getTickets({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      ticketList.clear();
      filteredTicketList.clear();
    }

    if (currentPage > totalPages) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res =
          await Provider.of<HomeProvider>(context, listen: false).getTickets(
        doctorId: Provider.of<AuthProvider>(context, listen: false)
            .usermodel!
            .id
            .toString(),
        status: status,
        page: currentPage,
        limit: 10,
      );

      if (res.success) {
        var newTickets = (res.data['tickets'] as List<TicketModel>);
        var paginationInfo = res.data['pagination'] as Map<String, dynamic>;

        setState(() {
          ticketList.addAll(newTickets);
          filteredTicketList = List.from(ticketList);
          totalPages = paginationInfo['totalPages'];
          currentPage++;
        });
      } else {
        print("Failed to fetch tickets: ${res.msg}");
      }
    } catch (e) {
      print("Exception occurred while fetching tickets: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTicketList = ticketList;
      } else {
        filteredTicketList = ticketList.where((ticket) {
          return ticket.name!.toLowerCase().contains(query.toLowerCase()) ||
              ticket.disease!.name!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              ticket.patient!.name!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

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
        body: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SearchField(
                function: (value) {
                  setState(() {
                    _onSearchChanged(value);
                  });
                },
                sortList: sortList,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  if (homeProvider.isLoading) {
                    return const TicketShimmer();
                  } else if (filteredTicketList.isEmpty) {
                    return noDataView(context);
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredTicketList.length,
                      itemBuilder: (context, index) {
                        var data = filteredTicketList[index];

                        return TicketCard(ticket: data);
                      },
                    );
                  }
                },
              ),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: function,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.w),
        hintText: "Search for tickets",
        prefixIcon: const Icon(Iconsax.search_normal),
        hintStyle: TextStyle(
          color: AppColors.captionColor,
          fontWeight: FontWeight.bold,
        ),
        // suffixIcon: IconButton(
        //     onPressed: () {
        //       showSortBottomSheet(context, sortList);
        //     },
        //     icon: const Icon(Icons.filter_list_rounded)),
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
