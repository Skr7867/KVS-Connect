import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/team_member_api/team_member_api.dart';
import '../api/Retailer_Api/team_member_api/team_member_model.dart';
import '../api/Retailer_Api/team_member_delete_api/team_member_delete_api.dart';
import '../contants/user_storedata.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';
import 'add_team_member.dart';
import 'edit_team_member.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  GetRetailerTeamMembers? teamMembersData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF255FA2), // TOP gradient color
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    // appLoader.show(context);

    final rsp = TeamMemberApi().getAllTeamMembers();
    rsp
        .then((value) async {
          final teamMemberId = value.data.members.first.id;
          await AppPrefrence.putString("id", teamMemberId);
          print("hello one" + teamMemberId);
          await AppPrefrence.getString('id');
          log(value.toString());

          try {
            setState(() {
              teamMembersData = value;
              print("Data show${teamMembersData.toString()}");
              // print("data show opposite gender${oppositegenderMataches}");
            });
            appLoader.hide();
          } catch (e) {
            setState(() {
              // loadingData = false;
            });
          }
        })
        .onError((error, stackTrace) {
          showTost(error);
          print(error);
          appLoader.hide();
        })
        .whenComplete(() {
          appLoader.hide();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        flexibleSpace: _header(),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return ListView(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: _stats(isTablet),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: teamMembersData?.data.members.length,
                  itemBuilder: (context, index) {
                    if (teamMembersData?.data.members.isNotEmpty ?? false) {
                      var user = teamMembersData!.data.members[index];

                      return _memberCard(
                        name: user.fullname,
                        phone: user.mobile,
                        status: getCustomerStatus(user.status),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔶 Header
  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF255FA2), Color(0xFF102A43)],
        ),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(18),
        //   bottomRight: Radius.circular(18),
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Icon(Icons.group, color: Colors.white),
                    SizedBox(width: 6),
                    Text("My Team", style: AppTextStyles.heading18whiteBold),
                  ],
                ),

                Text(
                  "Manage members, roles, and access.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTeamMemberScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Add\nTeam"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔶 Stats
  Widget _stats(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatCard(
          "TOTAL TEAM",
          "${teamMembersData?.data.summary.total ?? '0'}",
          AppColors.primaryOrange,
        ),
        _StatCard(
          "ACTIVE TEAM",
          "${teamMembersData?.data.summary.active ?? '0'}",
          AppColors.BtnGreenBg,
        ),
      ],
    );
  }

  // 🔶 Member Card
  Widget _memberCard({
    required String name,
    required String phone,
    //required String initials,
    required MemberStatus status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // _avatar(initials),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.call, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // _iconBtn(Icons.remove_red_eye),
          _statusChip(status),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTeamMemberScreen()),
              );
            },
            child: _iconBtn(Icons.edit),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController reasonController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text("Delete Member"),
                    content: TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        //prefixText: "+91  ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter deletion reason",
                      ),
                      maxLines: 1,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await MemberDeleteApi.deleteMember(
                            deletionReason: reasonController.text,
                          );
                          appLoader.show(context);
                          if (result["success"]) {
                            appLoader.hide();
                            Fluttertoast.showToast(
                              msg: result['message'].toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            print("Deleted successfully");
                          } else {
                            print(result["message"]);
                          }

                          Navigator.pop(context); // close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text("Delete", style: AppTextStyles.body14w400),
                      ),
                    ],
                  );
                },
              );
            },
            child: _iconBtn(Icons.block, danger: true),
          ),
        ],
      ),
    );
  }
}

Widget _iconBtn(IconData icon, {bool danger = false}) {
  return Container(
    margin: const EdgeInsets.only(left: 6),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: danger ? Colors.red.shade50 : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, size: 18, color: danger ? Colors.red : Colors.black54),
  );
}

Widget _statusChip(MemberStatus status) {
  late Color color;
  late String label;

  switch (status) {
    case MemberStatus.active:
      color = AppColors.BtnGreenBg;
      label = "Active";
      break;
    case MemberStatus.pending:
      color = AppColors.primaryOrange;
      label = "Pending";
      break;
    case MemberStatus.suspended:
      color = Colors.red;
      label = "Suspended";
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: TextStyle(color: color, fontSize: 12)),
  );
}

// 🔶 Bottom Navigation
Widget _bottomNav() {
  return BottomNavigationBar(
    currentIndex: 3,
    selectedItemColor: AppColors.primaryOrange,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
      BottomNavigationBarItem(icon: Icon(Icons.key), label: "My Key"),
      BottomNavigationBarItem(icon: Icon(Icons.group), label: "My Team"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
    ],
  );
}

// 🔹 Models & Data

enum MemberStatus { active, pending, suspended }

MemberStatus getCustomerStatus(String? status) {
  switch (status?.toLowerCase()) {
    case "active":
      return MemberStatus.active;
    case "completed":
      return MemberStatus.pending;
    case "overdue":
      return MemberStatus.suspended;
    default:
      return MemberStatus.active;
  }
}

class TeamMember {
  final String name;
  final String phone;
  final String initials;
  final MemberStatus status;

  TeamMember(this.name, this.phone, this.initials, this.status);
}

final teamMembers = [
  TeamMember("Rohit Mehra", "+91 98100 11111", "RM", MemberStatus.active),
  TeamMember("Anita Verma", "+91 98990 22222", "AV", MemberStatus.active),
  TeamMember("Vikas Singh", "+91 99110 33333", "VS", MemberStatus.active),
  TeamMember("Neha Shah", "+91 98765 44444", "NS", MemberStatus.pending),
  TeamMember("Kabir Khan", "+91 98220 55555", "KK", MemberStatus.active),
  TeamMember("Rahul Jain", "+91 97111 66666", "RJ", MemberStatus.suspended),
];

class _StatCard extends StatelessWidget {
  final String title, count;
  final Color color;

  const _StatCard(this.title, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(count, style: AppTextStyles.heading22w700white),
        ],
      ),
    );
  }
}
