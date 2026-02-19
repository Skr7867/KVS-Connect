import 'package:flutter/material.dart';

import '../text_style/colors.dart';

class NotificationsScreenDistibutor extends StatelessWidget {
  const NotificationsScreenDistibutor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Row(
          children: [
            Icon(Icons.notifications, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterTabs(),
            const SizedBox(height: 16),
            _actionsRow(),
            const SizedBox(height: 20),
            _sectionTitle("Today"),
            _notificationCard(
              icon: Icons.key,
              color: AppColors.primaryOrange,
              title: "Key sold by your team",
              subtitle:
              "Rohit Retail activated 1 key for ₹799. Remaining...",
              time: "2 min ago",
              unread: true,
            ),
            _notificationCard(
              icon: Icons.person_add,
              color: Colors.green,
              title: "New distributor joined",
              subtitle:
              "Akash Verma joined using your referral link.",
              time: "15 min ago",
              unread: true,
            ),
            _notificationCard(
              icon: Icons.currency_rupee,
              color: Colors.green,
              title: "Referral commission credited",
              subtitle:
              "You earned ₹150 (1%) from Silver Plan purchase.",
              time: "28 min ago",
              unread: true,
            ),
            _notificationCard(
              icon: Icons.verified,
              color: Colors.blue,
              title: "KYC approved",
              subtitle:
              "Your KYC documents have been verified & approved.",
              time: "1 hr ago",
              unread: true,
            ),
            const SizedBox(height: 24),
            _sectionTitle("This Week"),
            _notificationCard(
              icon: Icons.key,
              color: AppColors.primaryOrange,
              title: "Keys allocated",
              subtitle:
              "You allocated 25 keys to Team North.",
              time: "Tue, 11:24 AM",
            ),
            _notificationCard(
              icon: Icons.store,
              color: Colors.green,
              title: "Retailer joined",
              subtitle:
              "Mobile Mart joined via your referral link.",
              time: "Mon, 6:42 PM",
            ),
            _notificationCard(
              icon: Icons.settings,
              color: Colors.purple,
              title: "App update",
              subtitle:
              "New version available with faster key allocation.",
              time: "Sun, 10:05 AM",
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip("All", selected: true),
          _chip("Sales"),
          _chip("Referrals"),
          _chip("System"),
        ],
      ),
    );
  }

  Widget _chip(String text, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _actionsRow() {
    return Row(
      children: [
        Switch(
          value: false,
          onChanged: (_) {},
          activeColor: Colors.deepOrange,
        ),
        const Text("Unread only"),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check_circle,
              color: Colors.deepOrange),
          label: const Text(
            "Mark all as read",
            style: TextStyle(color: Colors.deepOrange),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepOrange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    bool unread = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey),
              ),
              if (unread)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}

