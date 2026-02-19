import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/Retailer/my_team_screen.dart';
import 'package:safeemilocker/api/Distibutor_Api/add_team_member_api/member_list_api.dart';

import '../api/Distibutor_Api/add_team_member_api/member_data_api.dart';
import '../api/Distibutor_Api/add_team_member_api/member_list_model.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import 'add_member_screen.dart';
import 'allocate_key_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {

  TextEditingController teamMembersController = TextEditingController();

  List<Member> filteredMember = [];
  TeamResponse? teamData;
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
      final value = await MemberDataApi().getAllMembers();
      setState(() {
        teamData =  value;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load team members");
    } finally {
      appLoader.hide();
    }
  }

  Future<void> fetchrRetailer() async {
    try {
      final value = await MemberListApi().get(
        page: 1,
        limit: 20,
        search: teamMembersController.text,
        accountStatus: "ACTIVE",
      );

      final List membersJson =
          value["data"]?["members"] ?? [];

      setState(() {
        showSearchWidgets = true;
        filteredMember =
            membersJson.map((e) => Member.fromJson(e)).toList();
      });
    } catch (e) {
      log("team members API Error: $e");
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
          "Team",
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
            _sectionTitle("TEAM OVERVIEW"),
            _teamOverviewCard(),
            const SizedBox(height: 16),

            Row(
              children:  [
                Expanded(
                  child: _SmallStatCard(
                    title: "Active Members",
                    value: "${teamData?.data.summary.active}",
                    color: Colors.green,
                    icon: Icons.flash_on,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SmallStatCard(
                    title: "Inactive/Blocked",
                    value: "${teamData?.data.summary.inactive}",
                    color: Colors.red,
                    icon: Icons.block,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle("MANAGE TEAM"),
            Row(
              children: [
                Expanded( child: InkWell(
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AddMemberScreen(),),);
                  },
                  borderRadius: BorderRadius.circular(12),

                  child: _actionChip(
                    "Add Member",
                    Icons.person_add,
                    const Color(0xffDFF8E6),
                    Colors.green,
                  ),
                ),),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionChip(
                    "Performance",
                    Icons.show_chart,
                    const Color(0xffFFE9CC),
                    AppColors.primaryOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle("TEAM LIST"),
            _teamListCard(),

            const SizedBox(height: 20),
            _sectionTitle("QUICK ACTIONS"),
            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    "Message All",
                    Icons.mail,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    "Export List",
                    Icons.download,
                    AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //bottomNavigationBar: _bottomNav(),
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

  // 🔹 Team Overview
  Widget _teamOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Team Members",
                style: TextStyle(color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.group, color: Colors.green),
              )
            ],
          ),
          const SizedBox(height: 6),
           Text(
            "${teamData?.data.summary.total}",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.94,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          )
        ],
      ),
    );
  }

  // 🔹 Team List
  Widget _teamListCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _searchBar(),
              ),
              const SizedBox(width: 8),
              _filterBox(),
            ],
          ),
          const SizedBox(height: 12),
          _tableHeader(),
          const Divider(),
          _buildCustomerList(),
          /*_teamRow(1, "Rahul", "9876512001", "Lucknow", true),
          _teamRow(2, "Neha", "9876512002", "Kanpur", true),
          _teamRow(3, "Ravi", "9876512003", "Varanasi", false),
          _teamRow(4, "Simran", "9876512004", "Prayagraj", true),*/
          const SizedBox(height: 10),
          _moreButton(),
        ],
      ),
    );
  }
  Widget _buildCustomerList() {
    /// DEFAULT LIST
    if (!showSearchWidgets) {
      final members = teamData?.data.members ?? [];
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final user = members[index];
          return _teamRow("${user.fullname}", "${user.mobile}", user.status == "ACTIVE");
        },
      );
    }

    /// SEARCH – NO DATA
    if (filteredMember.isEmpty) {
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
      itemCount: filteredMember.length, // ✅ FIXED
      itemBuilder: (context, index) {
        final user = filteredMember[index];
        return _teamRow("${user.fullname}", "${user.mobile}", user.status == "ACTIVE");
      },
    );
  }
  Widget _teamRow(
       String name, String number, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
        //  SizedBox(width: 20, child: Text("$id")),
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 3, child: Text(number)),
          //Expanded(flex: 2, child: Text(area)),
          _statusChip(isActive),
        ],
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
       // SizedBox(width: 20, child: Text("#")),
        Expanded(flex: 2, child: Text("Name")),
        Expanded(flex: 3, child: Text("Number")),
      //  Expanded(flex: 2, child: Text("Area")),
        Text("Status"),
      ],
    );
  }

  Widget _moreButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          "More Team",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // 🔹 UI Helpers
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

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: teamMembersController,
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
                  filteredMember.clear();
                });
              } else {
                fetchrRetailer();
              }
            },
          ),
        ),
        const SizedBox(width: 10),
      //  _filterButton(),
        const SizedBox(width: 8),
        // _iconButton(Icons.filter_alt),
      ],
    );
  }

  Widget _filterBox() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Text("All Status"),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _actionChip(
      String text, IconData icon, Color bg, Color iconColor) {
    return Container(
      height: 44,
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
                color: iconColor, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _quickAction(String text, IconData icon, Color color) {
    return Container(
      height: 46,
      decoration: _cardDecoration(),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style:
              TextStyle(color: color, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
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

// 🔹 Small Stat Card
class _SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SmallStatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
