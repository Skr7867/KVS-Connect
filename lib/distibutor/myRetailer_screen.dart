import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/api/Distibutor_Api/retailer_list_api/retailer_list_model.dart';

import '../api/Distibutor_Api/retailer_list_api/retailer_data_api.dart';
import '../api/Distibutor_Api/retailer_list_api/retailer_list_api.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import 'add_member_new_retailer.dart';

class MyRetailersScreen extends StatefulWidget {
  const MyRetailersScreen({super.key});

  @override
  State<MyRetailersScreen> createState() => _MyRetailersScreenState();
}

class _MyRetailersScreenState extends State<MyRetailersScreen> {
  TextEditingController retailerController = TextEditingController();
  List<Retailer> filteredRetailer = [];
  RetailerResponseModel? retailerData;
  /// 🔑 false = default list, true = search list
  bool showSearchWidgets = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    appLoader.show(context);
    try {
      final value = await RetailerDataApi().getAllRetailler();
      setState(() {
        retailerData =  value;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load customers");
    } finally {
      appLoader.hide();
    }
  }

  Future<void> fetchrRetailer() async {
    try {
      final value = await RetailerListApi().get(
        page: 1,
        limit: 20,
        search: retailerController.text,
        accountStatus: "ACTIVE",
      );

      final List retailersJson =
          value["data"]?["retailers"] ?? [];

      setState(() {
        showSearchWidgets = true;
        filteredRetailer =
            retailersJson.map((e) => Retailer.fromJson(e)).toList();
      });
    } catch (e) {
      log("Retailer API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "My Retailers",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("RETAILER OVERVIEW"),
            Row(
              children:  [
                Expanded(
                  child: _OverviewCard(
                    value: "${retailerData?.summary.total}",
                    label: "Retailers",
                    icon: Icons.store,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _OverviewCard(
                    value: "${retailerData?.summary.active}",
                    label: "Active",
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _OverviewCard(
                    value: "${retailerData?.summary.inactive}",
                    label: "Inactive",
                    icon: Icons.block,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle("QUICK ACTIONS"),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AddNewRetailerScreen(),),);
                    },
                    borderRadius: BorderRadius.circular(12),
                  child: _actionButton(
                    "Add Retailer",
                    Icons.person_add,
                    const Color(0xffDFF8E6),
                    Colors.green,
                  ),
                ),),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    "Invite via Link",
                    Icons.link,
                    const Color(0xffFFE8CC),
                    AppColors.primaryOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle("FILTER & SEARCH"),
            Row(
              children: [
                Expanded(child: _searchBar()),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle("RETAILER LIST"),
            _retailerListCard(),
          ],
        ),
      ),
     // bottomNavigationBar: _bottomNav(),
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // 🔹 Retailer List
  Widget _retailerListCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _tableHeader(),
          const Divider(),
          _buildCustomerList(),
          /*_row(1, "Rahul Store", "9876543210", true, "RS"),
          _row(2, "Varun Mobile", "9898989898", true, "VM"),
          _row(3, "Smart Kiosk", "9123456780", false, "SK"),
          _row(4, "Mobile Mart", "9000012345", true, "MM"),
          _row(5, "Nexus Mob", "9811222333", true, "NM"),*/
          const SizedBox(height: 12),
          _loadMoreButton(),
        ],
      ),
    );
  }
  Widget _buildCustomerList() {
    /// DEFAULT LIST
    if (!showSearchWidgets) {
      final retailers = retailerData?.retailers ?? [];
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: retailers.length,
        itemBuilder: (context, index) {
          final user = retailers[index];
          return _row(1, "${user.ownerName}", "${user.mobile}", true);
        },
      );
    }

    /// SEARCH – NO DATA
    if (filteredRetailer.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No data found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    /// SEARCH RESULT LIST
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRetailer.length, // ✅ FIXED
      itemBuilder: (context, index) {
        final user = filteredRetailer[index];
        return _row(1, user.ownerName, user.mobile, true);
      },
    );
  }

  Widget _row(
      int index, String name, String number, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text("$index")),
          /*CircleAvatar(
            radius: 14,
            backgroundColor: Colors.green.withOpacity(0.15),
            child: Text(
              initials,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),*/
          const SizedBox(width: 8),
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 2, child: Text(number)),
          Icon(
            active ? Icons.check_circle : Icons.cancel,
            color: active ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 6),
          const Icon(Icons.more_vert, size: 18),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
       // SizedBox(width: 20, child: Text("#")),
        SizedBox(width: 36),
        Expanded(flex: 2, child: Text("Name")),
        Expanded(flex: 2, child: Text("Number")),
        Text("Status"),
        SizedBox(width: 20),
      ],
    );
  }

  // 🔹 UI Helpers
  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: retailerController,
            decoration: InputDecoration(
              hintText: "Search name, phone",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              if (value
                  .trim()
                  .isEmpty) {
                setState(() {
                  showSearchWidgets = false;
                  filteredRetailer.clear();
                });
              } else {
                fetchrRetailer();
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        _filterButton(),
        const SizedBox(width: 8),
        // _iconButton(Icons.filter_alt),
      ],
    );
  }
  Widget _filterButton() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          "All Status",
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _actionButton(
      String text, IconData icon, Color bg, Color color) {
    return Container(
      height: 46,
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _loadMoreButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Load More Retailers",
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team"),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "Retailers"),
        BottomNavigationBarItem(icon: Icon(Icons.key), label: "Keys"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}

// 🔹 Overview Card
class _OverviewCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _OverviewCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
