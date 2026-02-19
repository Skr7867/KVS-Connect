import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/Shop/filter_screen.dart';

import 'product details_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Pro Wireless Headphones",
      "price": "\$299.00",
      "stock": "In Stock",
      "image": "https://i.imgur.com/hE2cAyC.jpeg",
      "stockColor": Colors.green,
    },
    {
      "name": "Smart Watch Ultra",
      "price": "\$749.00",
      "stock": "Low Stock (5)",
      "image": "https://i.imgur.com/hE2cAyC.jpeg",
      "stockColor": Colors.orange,
    },
    {
      "name": "Mark IV DSLR",
      "price": "\$2,199",
      "stock": "Out of Stock",
      "image": "https://i.imgur.com/JqKDdxj.png",
      "stockColor": Colors.red,
    },
  ];

  final List<IconData> categories = [
    Icons.laptop,
    Icons.checkroom,
    Icons.chair,
    Icons.local_drink,
    Icons.memory,
  ];

  final List<String> categoryNames = [
    "Electronics",
    "Apparel",
    "Home",
    "Groceries",
    "Hardware",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),

      body: Column(
        children: [
          /// HEADER
          _header(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// CATEGORIES
                  _categorySection(),

                  const SizedBox(height: 20),

                  /// FEATURED PRODUCTS
                  _featuredHeader(),

                  const SizedBox(height: 14),

                  _productGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff243447), Color(0xff1B2838)],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Marketplace",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Stack(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white54),
                      SizedBox(width: 8),
                      Text(
                        "Search products...",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FilterScreen()),
                  );
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CATEGORY SECTION
  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ALL CATEGORIES",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, i) {
              bool selected = i == 0;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xff243447)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        categories[i],
                        color: selected ? Colors.amber : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      categoryNames[i],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // FEATURED HEADER
  Widget _featuredHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "FEATURED PRODUCTS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 1,
          ),
        ),
        Text(
          "124 items",
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ],
    );
  }

  // PRODUCT GRID
  Widget _productGrid() {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .68,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, i) {
        final p = products[i];
        bool out = p["stock"] == "Out of Stock";

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(p["image"], fit: BoxFit.fitWidth),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  p["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 6),

                Text(
                  p["price"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: p["stockColor"]),
                    const SizedBox(width: 6),
                    Text(
                      p["stock"],
                      style: TextStyle(fontSize: 12, color: p["stockColor"]),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: out ? Colors.grey.shade300 : const Color(0xff243447),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    out ? "Sold Out" : "Add to Cart",
                    style: TextStyle(
                      color: out ? Colors.black45 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
