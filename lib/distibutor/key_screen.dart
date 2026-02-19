import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/api/Distibutor_Api/keys_api/keys_model.dart';
import 'package:safeemilocker/distibutor/allocate_key_screen.dart';

import '../api/Distibutor_Api/keys_api/keys_data_api.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';
import 'buy_key_package.dart';

class KeysScreen extends StatefulWidget {
  const KeysScreen({super.key});

  @override
  State<KeysScreen> createState() => _KeysScreenState();
}

class _KeysScreenState extends State<KeysScreen> {


  bool showSearchWidgets = false;

  KeysResponse? keyData;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    appLoader.show(context);
    try {
      final value = await KeysDataApi().getAllkeys();
      setState(() {
        keyData =  value;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load keys list");
    } finally {
      appLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Keys",
          style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topStats(),
            const SizedBox(height: 20),

            _sectionTitle("Quick Actions", Icons.flash_on),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded( child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BuyKeyPackageScreen(),),);
                    },
                    borderRadius: BorderRadius.circular(12),

                  child: _actionButton(
                      "Request Keys", Icons.shopping_bag, AppColors.primaryOrange),
                )),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AllocateKeyScreen(),),);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: _actionButton(
                      "Allocate Key", Icons.share, Colors.deepOrange),
                ),),
              ],
            ),

            /*const SizedBox(height: 24),
            _sectionTitle("Filter & Search", Icons.filter_alt),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _searchField()),
                const SizedBox(width: 12),
                _statusDropdown(),
              ],
            ),
*/
            const SizedBox(height: 24),
            _sectionTitle("Keys List", Icons.list),
            const SizedBox(height: 12),
            _buildKeysList(),
          ],
        ),
      ),
    );
  }

  // 🔹 Top Stats
  Widget _topStats() {
    return Row(
      children: [
        _statCard("${keyData?.data.summary.totalKeys}", "Total Keys", Icons.key, Colors.blue),
        _statCard("${keyData?.data.summary.assigned}", "Allocated", Icons.check_circle, Colors.green),
        _statCard("${keyData?.data.summary.available}", "Unused", Icons.inventory, Colors.grey),
      ],
    );
  }

  Widget _statCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style:
              const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Action Button
  Widget _actionButton(String text, IconData icon, Color color) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 🔹 Search
  Widget _searchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search by key ID or retailer",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Text("All Status"),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // 🔹 Keys List
 /* Widget _keysList() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: List.generate(7, (index) {
          return _keyRow(
            index + 1,
            "KEY-${["1A9X7", "9B3Q2", "7C8M5", "2Z6H1", "5VIN0", "8D2F3", "3J7R4"][index]}",
            ["Rahul Store", "Varun Mobile", "-", "Smart Kiosk", "Mobile Mart", "Nexus Mob", "Indore Mob"][index],
            ["Noida", "Delhi", "-", "Pune", "Agra", "Kanpur", "Indore"][index],
            index,
          );
        }),
      ),
    );
  }*/
  Widget _buildKeysList() {
    if (!showSearchWidgets) {
      final keys = keyData?.data.keys ?? [];

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];

          return _keyRow(
            key.keyCode,
            key.displayStatus,
            key.status, // ✅ STRING status
          );
        },
      );
    }

    return const SizedBox();
  }
  /// SEARCH – NO DATA
    /*if (filteredRetailer.isEmpty) {
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
  }*/
  Widget _keyRow(String keyId, String retailer, String status) {
    IconData icon;
    Color color;

    switch (status) {
      case "AVAILABLE":
        icon = Icons.radio_button_unchecked;
        color = Colors.grey;
        break;

      case "ASSIGNED":
        icon = Icons.check_circle;
        color = Colors.green;
        break;

      case "EXPIRED":
        icon = Icons.cancel;
        color = Colors.red;
        break;

      default:
        icon = Icons.arrow_circle_right;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              keyId,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(
            child: Icon(icon, color: color),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.store, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(child: Text(retailer)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // 🔹 Section Title
  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 18),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
      ],
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
}
