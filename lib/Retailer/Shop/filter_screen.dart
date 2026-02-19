import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/Shop/round_button.dart';
import 'package:safeemilocker/text_style/colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  /// CATEGORY CHECKBOXES
  Map<String, bool> categories = {
    "Headphone": true,
    "Chargers": false,
    "Mobile Covers": false,
    "Earbuds": false,
    "Mobiles": false,
  };

  /// STOCK RADIO
  String stockValue = "In Stock";

  /// PRICE RANGE
  RangeValues priceRange = const RangeValues(1000, 50000);

  /// EXPANSION STATE
  bool showCategory = true;
  bool showPrice = true;
  bool showStock = true;
  bool showBrand = false;
  bool showSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Filters",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Reset",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// CATEGORY
                _sectionCard(
                  title: "Category",
                  icon: Icons.layers,
                  expanded: showCategory,
                  onTap: () => setState(() => showCategory = !showCategory),
                  child: Column(
                    children: categories.keys.map((e) {
                      return CheckboxListTile(
                        value: categories[e],
                        onChanged: (v) {
                          setState(() => categories[e] = v!);
                        },
                        title: Text(e),
                        secondary: Text(_categoryCount(e)),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                ),

                /// PRICE RANGE
                _sectionCard(
                  title: "Price Range",
                  icon: Icons.currency_rupee,
                  expanded: showPrice,
                  onTap: () => setState(() => showPrice = !showPrice),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _priceBox("Min", priceRange.start),
                          const Text("—"),
                          _priceBox("Max", priceRange.end),
                        ],
                      ),

                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 100000,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() => priceRange = value);
                        },
                      ),
                    ],
                  ),
                ),

                /// STOCK
                _sectionCard(
                  title: "Stock Availability",
                  icon: Icons.inventory_2,
                  expanded: showStock,
                  onTap: () => setState(() => showStock = !showStock),
                  child: Column(
                    children: [
                      _radioStock("In Stock", Colors.green),
                      _radioStock("Low Stock", Colors.orange),
                      _radioStock("Out of Stock", Colors.red),
                    ],
                  ),
                ),

                /// BRAND
                _sectionCard(
                  title: "Brand",
                  icon: Icons.sell,
                  expanded: showBrand,
                  onTap: () => setState(() => showBrand = !showBrand),
                  child: const SizedBox(),
                ),

                /// SORT
                _sectionCard(
                  title: "Sort By",
                  icon: Icons.sort,
                  expanded: showSort,
                  onTap: () => setState(() => showSort = !showSort),
                  child: const SizedBox(),
                ),
              ],
            ),
          ),

          /// BOTTOM BUTTONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: RoundButton(
                    buttonColor: Colors.red,
                    title: 'Clear All',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundButton(
                    buttonColor: AppColors.primaryOrange,
                    title: 'Apply Filter',
                    onPress: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION CARD
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(icon, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          if (expanded) ...[const SizedBox(height: 12), child],
        ],
      ),
    );
  }

  /// PRICE BOX
  Widget _priceBox(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            "₹${value.toInt()}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// STOCK RADIO
  Widget _radioStock(String value, Color dotColor) {
    return RadioListTile(
      value: value,
      groupValue: stockValue,
      onChanged: (v) => setState(() => stockValue = v!),
      title: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: dotColor),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  String _categoryCount(String name) {
    switch (name) {
      case "Headphone":
        return "48";
      case "Chargers":
        return "32";
      case "Mobile Covers":
        return "24";
      case "Earbuds":
        return "67";
      case "Mobiles":
        return "19";
      default:
        return "";
    }
  }
}
