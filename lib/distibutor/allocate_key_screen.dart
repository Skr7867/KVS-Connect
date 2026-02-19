import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';

import '../api/Distibutor_Api/allocate_key_api/allocate_keys_api.dart';
import '../api/Distibutor_Api/keys_api/keys_data_api.dart';
import '../api/Distibutor_Api/keys_api/keys_model.dart';
import '../api/Distibutor_Api/retailer_list_api/retailer_list_api.dart';
import '../api/Distibutor_Api/retailer_list_api/retailer_list_model.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';

class AllocateKeyScreen extends StatefulWidget {
  const AllocateKeyScreen({super.key});

  @override
  State<AllocateKeyScreen> createState() => _AllocateKeyScreenState();
}

class _AllocateKeyScreenState extends State<AllocateKeyScreen> {
  KeysResponse? keyData;
  @override
  void initState() {
    super.initState();
    getRetailerData();
    getData();
  }

  Future<void> getData() async {
    appLoader.show(context);
    try {
      final value = await KeysDataApi().getAllkeys();
      setState(() {
        keyData = value;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load keys list");
    } finally {
      appLoader.hide();
    }
  }

  TextEditingController date = TextEditingController();
  bool whatsapp = true;
  bool sms = false;
  TextEditingController keys = TextEditingController();
  TextEditingController note = TextEditingController();
  String? selectedRetailerName;
  String? selectedRetailerId;
  RetailerResponseModel? retailerData;
  List<Map<String, dynamic>> retailerList = [];
  List<Retailer> filteredRetailer = [];
  List<Map<String, dynamic>> retailersJson = [];
  Future<void> _allocateKeys() async {
    if (selectedRetailerId == null) {
      Fluttertoast.showToast(msg: "Please select a retailer");
      return;
    }

    appLoader.show(context);

    try {
      final response = await AllocateKeyApi().allocateKey(
        retailerId: selectedRetailerId!, // 👈 dropdown se
        quantity: int.parse(keys.text),
        validTo: date.text, // yyyy-MM-dd
        notes: note.text.isEmpty ? "Initial allocation" : note.text,
      );

      Fluttertoast.showToast(msg: "Keys allocated successfully ✅");
      print("API RESPONSE 👉 $response");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to allocate keys");
      print("ERROR 👉 $e");
    } finally {
      appLoader.hide();
    }
  }

  Future<void> getRetailerData() async {
    appLoader.show(context);
    try {
      final value = await RetailerListApi().get();
      final List retailersJson = value["data"]?["retailers"] ?? [];

      setState(() {
        filteredRetailer = retailersJson
            .map((e) => Retailer.fromJson(e))
            .toList();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load customers");
    } finally {
      appLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> retailerNames = filteredRetailer
        .map((e) => e.ownerName)
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text("Allocate Key", style: AppTextStyles.heading18whiteBold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ------------------ STATS ------------------
            Row(
              children: [
                Flexible(
                  child: _StatCard(
                    icon: Icons.key,
                    value: "${keyData?.data.summary.totalKeys}",
                    label: "Total Keys",
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Flexible(
                  child: _StatCard(
                    icon: Icons.open_in_new,
                    value: "${keyData?.data.summary.assigned}",
                    label: "Allocated",
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Flexible(
                  child: _StatCard(
                    icon: Icons.inventory_2,
                    value: "${keyData?.data.summary.available}",
                    label: "Unused",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// ------------------ FORM ------------------
            _allocationForm(retailerNames),
          ],
        ),
      ),
    );
  }

  /// ------------------ FORM ------------------
  Widget _allocationForm(List<String> retailerNames) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Allocation Form",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          /// Retailer + Quantity
          Row(
            children: [
              Expanded(
                child: _dropdownField(
                  hint: "Choose Retailer",
                  items: retailerNames,
                  selectedValue: selectedRetailerName,
                  onChanged: (value) {
                    setState(() {
                      selectedRetailerName = value;
                      final retailer = filteredRetailer.firstWhere(
                        (e) => e.ownerName == value,
                      );
                      selectedRetailerId = retailer.user.id;
                    });
                  },
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _input(
                  label: "No of keys",
                  hint: "Enter keys",
                  controller: keys,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          const SizedBox(height: 12),
          _dateField(label: "Valid Till", controller: date),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _input(
                  label: "Note",
                  hint: "Enter note",
                  controller: note,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),

          /*CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Send key instantly on WhatsApp"),
            value: whatsapp,
            onChanged: (v) => setState(() => whatsapp = v!),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Also send SMS copy"),
            value: sms,
            onChanged: (v) => setState(() => sms = v!),
          ),*/
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                child: _actionButton(
                  "Allocate",
                  Icons.check,
                  Colors.orange,
                  onTap: () {
                    _allocateKeys();
                  },
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: _actionButton(
                  "Reset",
                  Icons.refresh,
                  const Color(0xffFFE8CC),
                  textColor: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ------------------ WIDGETS ------------------
  Widget _dropdownField({
    required String hint,
    required List<String> items,
    String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: selectedValue,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller.text =
                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    String text,
    IconData icon,
    Color color, {
    Color textColor = Colors.white,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: enabled ? color : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------ STAT CARD ------------------
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
