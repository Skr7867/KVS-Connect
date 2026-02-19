import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "3",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PRODUCT IMAGE
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            "https://i.imgur.com/hE2cAyC.jpeg",
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_border),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DOT INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: index == 0 ? 18 : 6,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.black
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// PRODUCT CARD
                  _productInfoCard(),

                  const SizedBox(height: 12),

                  _expandTile("Specifications"),
                  _expandTile("Payment Options"),
                  _expandTile("Delivery Information"),

                  const SizedBox(height: 12),

                  _quantitySelector(),
                ],
              ),
            ),
          ),

          /// BOTTOM BUTTONS
          _bottomButtons(),
        ],
      ),
    );
  }

  /// PRODUCT INFO CARD
  Widget _productInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pro Wireless Headphones",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Text(
                "₹24,999",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text(
                "₹29,999",
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "17% OFF",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.circle, size: 8, color: Colors.green),
              SizedBox(width: 6),
              Text("In Stock"),
              SizedBox(width: 4),
              Text(
                "(24 units available)",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            "Experience premium sound quality with active noise cancellation, Bluetooth 5.3 connectivity, and up to 40-hour battery life.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// EXPANSION TILE
  Widget _expandTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        title: Text(title),
        children: const [
          Padding(padding: EdgeInsets.all(16), child: Text("Details here...")),
        ],
      ),
    );
  }

  /// QUANTITY
  Widget _quantitySelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Quantity"),
          Row(
            children: [
              _qtyBtn(Icons.remove),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("1", style: TextStyle(fontSize: 16)),
              ),
              _qtyBtn(Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(icon: Icon(icon, size: 18), onPressed: () {}),
    );
  }

  /// BOTTOM BUTTONS
  Widget _bottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text("Add to Cart"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text("Buy Now"),
            ),
          ),
        ],
      ),
    );
  }
}
