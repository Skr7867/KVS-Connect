import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../text_style/app_text_styles.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  void openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/917004977976");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  void makePhoneCall() async {
    final Uri url = Uri.parse("tel:+917004977976");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch dialer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        leading: BackButton(color: Colors.white),
        title: Text("Support", style: AppTextStyles.heading18whiteBold),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final gridCount = isTablet ? 4 : 2;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _helpBanner(),
                  const SizedBox(height: 16),
                  _primaryActions(gridCount),

                  const Spacer(), // ye content ko upar push karega

                  Center(
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // row ko center me rakhega
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/image/KVSAppLogo.png',
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8), // spacing correct
                        Text(
                          "Made In India",
                          style: AppTextStyles.body14w400textColorgrey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12), // thoda bottom spacing
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔶 Help Banner
  Widget _helpBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 0.1,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.headset_mic, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEED ANY HELP?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Retailer Support Center",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Get instant help for keys, EMIs, app issues & onboarding.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔶 Primary Actions
  Widget _primaryActions(int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: count,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        InkWell(
          onTap: makePhoneCall,
          child: _actionCard(
            Icons.call,
            "Call Support",
            "9:30 AM - 7:30 PM",
            const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
        ),
        InkWell(
          onTap: openWhatsApp,
          child: _actionCard(
            Icons.phone,
            "WhatsApp Helpdesk",
            "Avg reply in 10 mins",
            const LinearGradient(
              colors: [Color(0xFF16A34A), Color(0xFF15803D)],
            ),
          ),
        ),
        /*_actionCard(
          Icons.confirmation_number,
          "Create Ticket",
          "Issue with key / EMI",
          const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          ),
        ),
        _actionCard(
          Icons.menu_book,
          "Help Articles",
          "Step-by-step guides",
          const LinearGradient(
            colors: [Color(0xFF9333EA), Color(0xFF7E22CE)],
          ),
        ),
        _actionCard(
          Icons.bug_report,
          "Report Bug",
          "App / portal issue",
          const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          ),
        ),*/
      ],
    );
  }

  Widget _actionCard(
    IconData icon,
    String title,
    String subtitle,
    Gradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 🔶 Section Header
  Widget _sectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(action, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // 🔶 Ticket Card
  Widget _ticketCard(
    String title,
    String subtitle,
    String status,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }

  // 🔶 FAQ Tile
  Widget _faqTile(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
