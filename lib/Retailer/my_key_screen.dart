import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';
import 'package:safeemilocker/widgets/custom_loader.dart';

import '../api/Retailer_Api/keys_api/keys_api.dart';
import '../api/Retailer_Api/keys_api/keys_api_model.dart';
import '../widgets/popup.dart';

class MyKeysScreen extends StatefulWidget {
  const MyKeysScreen({super.key});

  @override
  State<MyKeysScreen> createState() => _MyKeysScreenState();
}

class _MyKeysScreenState extends State<MyKeysScreen> {
  KeyModel? keyData;
  @override
  void initState() {
    getData();
  }

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day}/${d.month}/${d.year}";
  }

  getData() {
    appLoader.show(context);

    KeysApi.getKeys(
          /*  page: 1,
        limit: 20,
        status: "AVAILABLE",*/
        )
        .then((rsp) {
          if (rsp["success"] == true) {
            setState(() {
              keyData = KeyModel.fromJson(rsp["data"]);
            });
          } else {
            showTost(rsp["message"].toString());
          }
        })
        .catchError((error) {
          showTost(error.toString());
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _statsSection(isTablet),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: keyData?.data.keys.length,
                    itemBuilder: (context, index) {
                      if (keyData?.data.keys.isNotEmpty ?? false) {
                        var user = keyData?.data.keys[index];

                        return _keyCard(
                          key: user!.keyCode,
                          status: getKeysStatus(user.displayStatus),
                          validFrom: user.validFrom,
                          validTo: user.validTo,
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
      ),
    );
  }

  // 🔶 Header
  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF255FA2), Color(0xFF102A43)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Icon(Icons.key, color: Colors.white),
                    const SizedBox(width: 6),
                    Text("My Keys", style: AppTextStyles.heading18w700white),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Manage activations, unused keys, and expires.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          /* ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.25),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Buy\nKey"),
          ),*/
        ],
      ),
    );
  }

  // 🔶 Stats
  Widget _statsSection(bool isTablet) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatCard(
          "TOTAL KEYS",
          "${keyData?.data.summary.totalKeys}",
          AppColors.secondaryOrange,
        ),
        _StatCard(
          "ACTIVATED",
          "${keyData?.data.summary.assigned}",
          AppColors.BtnGreenBg,
        ),
        _StatCard(
          "AVAILABLE",
          "${keyData?.data.summary.available}",
          AppColors.primaryOrange,
        ),
      ],
    );
  }

  // 🔶 Key Card
  Widget _keyCard({
    required String key,
    required KeyStatus status,
    required String validFrom,
    required String validTo,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.key, color: AppColors.primaryOrange),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                _statusChip(status),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "From: ${formatDate(validFrom)}",
                style: const TextStyle(fontSize: 9),
              ),

              Text(
                "To: ${formatDate(validTo)}",
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(KeyStatus status) {
    late Color color;
    late String label;

    switch (status) {
      case KeyStatus.available:
        color = AppColors.colorBlue;
        label = "Available";
        break;
      case KeyStatus.activated:
        color = AppColors.BtnGreenBg;
        label = "Activated";
        break;
      case KeyStatus.expiring:
        color = AppColors.primaryOrange;
        label = "Expiring";
        break;
      case KeyStatus.expired:
        color = Colors.red;
        label = "Expired";
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

  // 🔶 Bottom Nav
  // Widget _bottomNav() {
  //   return BottomNavigationBar(
  //     currentIndex: 2,
  //     selectedItemColor: AppColors.primaryOrange,
  //     unselectedItemColor: Colors.grey,
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //       BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
  //       BottomNavigationBarItem(icon: Icon(Icons.key), label: "My Key"),
  //       BottomNavigationBarItem(icon: Icon(Icons.group), label: "My Team"),
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
  //     ],
  //   );
  // }
}

// 🔹 Models & Data

enum KeyStatus { available, activated, expiring, expired }

KeyStatus getKeysStatus(String? status) {
  switch (status?.toLowerCase()) {
    case "available":
      return KeyStatus.available;
    case "activated":
      return KeyStatus.activated;
    case "expiring":
      return KeyStatus.expiring;
    case "expired":
      return KeyStatus.expired;
    default:
      return KeyStatus.available;
  }
}

class KeyItem {
  final String key;
  final KeyStatus status;
  final String? user;
  final bool showActivate;

  KeyItem(this.key, this.status, {this.user, this.showActivate = false});
}

final keys = [
  KeyItem("KEY-9F4X-1021", KeyStatus.available, showActivate: true),
  KeyItem("KEY-AB12-7743", KeyStatus.activated, user: "Rohit"),
  KeyItem("KEY-PP45-6641", KeyStatus.expiring, user: "Anita"),
  KeyItem("KEY-EE99-3102", KeyStatus.expired),
  KeyItem("KEY-XY33-8890", KeyStatus.available, showActivate: true),
];

class _StatCard extends StatelessWidget {
  final String title, count;
  final Color color;

  const _StatCard(this.title, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Text(count, style: AppTextStyles.heading22w700white),
        ],
      ),
    );
  }
}
