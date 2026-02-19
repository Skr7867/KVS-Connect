import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Stay updated with your keys, EMIs & customer activity.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 14),

              _filterChips(),
              const SizedBox(height: 24),

              _section("TODAY"),
              _notification(
                icon: Icons.key,
                iconBg: Colors.blue.shade50,
                title: "New key credited to your account",
                subtitle:
                "Key ID: K-78123 can be used for new EMI activations.",
                tag: "+1 Key",
                tagColor: Colors.blue.shade100,
                time: "3 min ago",
                source: "Retailer Panel",
              ),
              _notification(
                icon: Icons.currency_rupee,
                iconBg: Colors.green.shade50,
                title: "EMI collected from Rohit Mehra",
                subtitle:
                "Payment received via UPI. Auto lock disabled for this cycle.",
                tag: "₹ 1,899",
                tagColor: Colors.green.shade100,
                time: "15 min ago",
                source: "Secure Mandate",
              ),
              _notification(
                icon: Icons.info,
                iconBg: Colors.blue.shade50,
                title: "System maintenance completed",
                subtitle: "All services are running smoothly. No action required.",
                tag: "Stable",
                tagColor: Colors.grey.shade200,
                time: "45 min ago",
                source: "Online",
              ),

              const SizedBox(height: 24),
              _section("THIS WEEK"),
              _notification(
                icon: Icons.receipt_long,
                iconBg: Colors.orange.shade50,
                title: "3 EMIs due in next 48 hours",
                subtitle:
                "Send reminders to avoid auto-locks & penalties for customers.",
                tag: "Follow up",
                tagColor: Colors.orange.shade100,
                time: "1 day ago",
                source: "Smart Alerts",
              ),
              _notification(
                icon: Icons.campaign,
                iconBg: Colors.purple.shade50,
                title: "Extra 10 keys at special pricing",
                subtitle:
                "Top up your key balance to activate more EMI customers instantly.",
                tag: "Limited",
                tagColor: Colors.purple.shade100,
                time: "2 days ago",
                source: "Key Credits",
              ),

              const SizedBox(height: 24),
              _section("EARLIER"),
              _notification(
                icon: Icons.verified_user,
                iconBg: Colors.green.shade50,
                title: "KYC verified for your retailer account",
                subtitle:
                "Your documents are approved. Higher credit control unlocked.",
                tag: "Verified",
                tagColor: Colors.green.shade100,
                time: "6 days ago",
                source: "Compliance",
              ),
              _notification(
                icon: Icons.warning,
                iconBg: Colors.red.shade50,
                title: "Auto-lock triggered for 1 device",
                subtitle:
                "Customer EMI overdue by 18 days. Share unlock OTP on payment.",
                tag: "Action",
                tagColor: Colors.red.shade100,
                time: "9 days ago",
                source: "Device Control",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Filter Chips
  Widget _filterChips() {
    return Wrap(
      spacing: 10,
      children: [
        _chip("All", true),
        _chip("System", false),
        _chip("Activity", false),
        _chip("Offers", false),
      ],
    );
  }

  Widget _chip(String text, bool selected) {
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      selectedColor: AppColors.primaryOrange,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
      onSelected: (_) {},
    );
  }

  // 🔹 Section Header
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.caption12bold

      ),
    );
  }

  // 🔹 Notification Card
  Widget _notification({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required String time,
    required String source,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                      const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(time,
                  style:
                  AppTextStyles.caption12),
              const SizedBox(width: 16),
              const Icon(Icons.circle, size: 4, color: Colors.grey),
              const SizedBox(width: 6),
              Text(source,
                  style: AppTextStyles.caption12),
            ],
          )
        ],
      ),
    );
  }
}
