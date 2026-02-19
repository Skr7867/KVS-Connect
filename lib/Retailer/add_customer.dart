import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safeemilocker/api/add_customer_api.dart';
import 'package:safeemilocker/contants/user_storedata.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';

import '../api/Retailer_Api/qr_code_api/policies_api.dart';
import '../api/upload_customer_documents_api.dart';
import '../widgets/custom_loader.dart';
import '../widgets/file_picker.dart';
import 'mandateScreen.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  double _calculateInstallment(int duration) {
    double total = double.tryParse(amount.text) ?? 0;
    if (duration == 0) return 0;
    return total / duration;
  }

  String _emiText(int duration) {
    double emi = _calculateInstallment(duration);
    switch (frequancy.text) {
      case "MONTHLY":
        return "₹${emi.toStringAsFixed(0)}/month";
      case "WEEKLY":
        return "₹${emi.toStringAsFixed(0)}/week";
      default:
        return "₹${emi.toStringAsFixed(0)}/14 days";
    }
  }

  File? customerPhoto;
  File? aadhaarFront;
  File? aadhaarBack;
  File? panCard;
  File? mobileBill;
  File? mobilePhoto;
  String paymentMode = "eNACH";
  int _currentStep = 0;

  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController customerid = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final TextEditingController accountholderName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController ifscCode = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController frequancy = TextEditingController();
  final TextEditingController intallment_duration = TextEditingController();
  final TextEditingController startdate = TextEditingController();
  final TextEditingController enddate = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController ram = TextEditingController();
  final TextEditingController color = TextEditingController();
  final TextEditingController model = TextEditingController();
  final TextEditingController imei_no1 = TextEditingController();
  final TextEditingController imei_no2 = TextEditingController();
  final TextEditingController refName1 = TextEditingController();
  final TextEditingController refName2 = TextEditingController();
  final TextEditingController refMobile1 = TextEditingController();
  final TextEditingController refMobile2 = TextEditingController();
  final TextEditingController phoneType = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateEndDate() {
    if (startdate.text.isEmpty || intallment_duration.text.isEmpty) return;

    DateTime start = DateTime.parse(startdate.text);
    int duration = int.tryParse(intallment_duration.text) ?? 0;
    DateTime end;

    switch (frequancy.text) {
      case "MONTHLY":
        end = DateTime(start.year, start.month + duration, start.day);
        break;
      case "WEEKLY":
        end = start.add(Duration(days: duration * 7));
        break;
      default:
        end = start.add(Duration(days: duration * 14));
    }

    enddate.text =
        "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
  }

  Future<void> scanImei(TextEditingController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Scan IMEI"),
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  controller.text = code;
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryOrange,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Customer",
              style: AppTextStyles.heading18whiteBold.copyWith(
                fontSize: isTablet ? 24 : 18,
              ),
            ),
            Text(
              "Fill customer details",
              style: AppTextStyles.text12w400White.copyWith(
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.task_alt, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  "Step ${_currentStep + 1}/3",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryOrange.withOpacity(0.1),
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
            ),
            child: Row(
              children: [
                if (isDesktop) _buildSideNavigation(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 20,
                      vertical: 20,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgressIndicator(),
                          const SizedBox(height: 24),
                          _buildCurrentStepContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSideNavigation() {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quick Navigation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ..._buildNavItems(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems() {
    final sections = [
      {"icon": Icons.person, "title": "Customer Details", "step": 0},
      {"icon": Icons.payment, "title": "Payment & Mandate", "step": 0},
      {"icon": Icons.upload_file, "title": "Documents", "step": 1},
      {"icon": Icons.phone_android, "title": "Mobile Details", "step": 1},
      {"icon": Icons.group, "title": "References", "step": 2},
    ];

    return sections.map((section) {
      return InkWell(
        onTap: () => setState(() => _currentStep = section["step"] as int),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _currentStep == section["step"]
                ? AppColors.primaryOrange.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                section["icon"] as IconData,
                color: _currentStep == section["step"]
                    ? AppColors.primaryOrange
                    : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                section["title"] as String,
                style: TextStyle(
                  color: _currentStep == section["step"]
                      ? AppColors.primaryOrange
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStep(0, "Basic Info"),
                  Expanded(child: _buildProgressLine(0)),
                  _buildStep(1, "Documents"),
                  Expanded(child: _buildProgressLine(1)),
                  _buildStep(2, "Review"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int step, String label) {
    bool isCompleted = _currentStep > step;
    bool isActive = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : (isActive ? AppColors.primaryOrange : Colors.grey.shade300),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    "${step + 1}",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.primaryOrange : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(int step) {
    bool isActive = _currentStep > step;
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildDocumentsStep();
      case 2:
        return _buildReviewStep();
      default:
        return _buildBasicInfoStep();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Customer Information",
          Icons.person_outline,
          "Enter basic customer details",
        ),
        const SizedBox(height: 20),
        _buildModernCard(
          child: Column(
            children: [
              _buildAnimatedField(
                controller: fullName,
                label: "Full Name",
                icon: Icons.person,
                isRequired: true,
                maxLength: 200,
              ),
              _buildAnimatedField(
                controller: mobileNumber,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                isRequired: true,
                maxLength: 10,
              ),
              _buildAnimatedField(
                controller: email,
                label: "Email Address",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                maxLength: 500,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(
          "Payment Method",
          Icons.payment,
          "Select payment mode and details",
        ),
        const SizedBox(height: 20),
        _buildModernCard(
          child: Column(
            children: [
              _buildPaymentModeToggle(),
              const SizedBox(height: 20),
              if (paymentMode == "eNACH") _buildENACHFields(),
              if (paymentMode == "UPI") _buildUPIFields(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(
          "Mandate Details",
          Icons.description,
          "Set up payment mandate",
        ),
        const SizedBox(height: 20),
        _buildModernCard(
          child: Column(
            children: [
              _buildAnimatedField(
                controller: amount,
                label: "Amount (₹)",
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                isRequired: true,
                maxLength: 500,
              ),
              _buildFrequencySelector(),
              _buildDurationSelector(),
              _buildDateRangePicker(),
              _buildAnimatedField(
                controller: notes,
                label: "Additional Notes",
                icon: Icons.note,
                maxLines: 3,
                maxLength: 500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Required Documents",
          Icons.upload_file,
          "Upload clear images of all documents",
        ),
        const SizedBox(height: 20),
        _buildModernCard(
          child: Column(
            children: [
              _buildDocumentUploader(
                title: "Customer Photo",
                icon: Icons.camera_alt,
                file: customerPhoto,
                onTap: (File file) {
                  // Explicitly type the parameter
                  setState(() {
                    customerPhoto = file;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDocumentUploader(
                title: "Aadhaar Front",
                icon: Icons.credit_card,
                file: aadhaarFront,
                onTap: (File file) {
                  setState(() {
                    aadhaarFront = file;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDocumentUploader(
                title: "Aadhaar Back",
                icon: Icons.credit_card,
                file: aadhaarBack,
                onTap: (File file) {
                  setState(() {
                    aadhaarBack = file;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDocumentUploader(
                title: "PAN Card",
                icon: Icons.assignment,
                file: panCard,
                onTap: (File file) {
                  setState(() {
                    panCard = file;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDocumentUploader(
                title: "Mobile Bill",
                icon: Icons.receipt,
                file: mobileBill,
                onTap: (File file) {
                  setState(() {
                    mobileBill = file;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(
          "Mobile Details",
          Icons.phone_android,
          "Enter mobile specifications",
        ),
        const SizedBox(height: 20),
        _buildModernCard(
          child: Column(
            children: [
              _buildDocumentUploader(
                title: "Mobile Photo",
                icon: Icons.photo_camera,
                file: mobilePhoto,
                onTap: (File file) {
                  setState(() {
                    mobilePhoto = file;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAnimatedField(
                controller: phoneType,
                label: "Phone Type",
                icon: Icons.devices,
                isRequired: true,
                maxLength: 500,
              ),
              _buildAnimatedField(
                controller: ram,
                label: "RAM Variant",
                icon: Icons.memory,
                isRequired: true,
                maxLength: 500,
              ),
              _buildAnimatedField(
                controller: color,
                label: "Color",
                icon: Icons.color_lens,
                isRequired: true,
                maxLength: 500,
              ),
              _buildAnimatedField(
                controller: model,
                label: "Model",
                icon: Icons.model_training,
                isRequired: true,
                maxLength: 500,
              ),
              _buildImeiField(controller: imei_no1, label: "IMEI Number 01"),
              _buildImeiField(controller: imei_no2, label: "IMEI Number 02"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Review Information",
          Icons.reviews,
          "Please verify all details before submitting",
        ),
        const SizedBox(height: 20),
        _buildReviewCard(
          title: "Customer Details",
          icon: Icons.person,
          children: [
            _buildReviewRow("Full Name", fullName.text),
            _buildReviewRow("Phone", mobileNumber.text),
            _buildReviewRow("Email", email.text),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: "Payment Details",
          icon: Icons.payment,
          children: [
            _buildReviewRow("Payment Mode", paymentMode),
            if (paymentMode == "eNACH") ...[
              _buildReviewRow("Bank Name", bankName.text),
              _buildReviewRow("Account Holder", accountholderName.text),
              _buildReviewRow("Account Number", accountNumber.text),
            ],
            if (paymentMode == "UPI")
              _buildReviewRow("UPI ID", upiIdController.text),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: "Mandate Details",
          icon: Icons.description,
          children: [
            _buildReviewRow("Amount", "₹${amount.text}"),
            _buildReviewRow("Frequency", frequancy.text),
            _buildReviewRow("Duration", "${intallment_duration.text} months"),
            _buildReviewRow("Start Date", startdate.text),
            _buildReviewRow("End Date", enddate.text),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: "Documents Status",
          icon: Icons.upload_file,
          children: [
            _buildDocumentStatus("Customer Photo", customerPhoto != null),
            _buildDocumentStatus("Aadhaar Front", aadhaarFront != null),
            _buildDocumentStatus("Aadhaar Back", aadhaarBack != null),
            _buildDocumentStatus("PAN Card", panCard != null),
            _buildDocumentStatus("Mobile Bill", mobileBill != null),
            _buildDocumentStatus("Mobile Photo", mobilePhoto != null),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: "Mobile Details",
          icon: Icons.phone_android,
          children: [
            _buildReviewRow("Phone Type", phoneType.text),
            _buildReviewRow("RAM", ram.text),
            _buildReviewRow("Color", color.text),
            _buildReviewRow("Model", model.text),
            _buildReviewRow("IMEI 1", imei_no1.text),
            _buildReviewRow("IMEI 2", imei_no2.text),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: "Reference Details",
          icon: Icons.group,
          children: [
            _buildReviewRow(
              "Reference 1",
              "${refName1.text} - ${refMobile1.text}",
            ),
            _buildReviewRow(
              "Reference 2",
              "${refName2.text} - ${refMobile2.text}",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primaryOrange, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "Not provided" : value,
              style: TextStyle(
                fontWeight: value.isEmpty ? FontWeight.normal : FontWeight.w500,
                color: value.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentStatus(String label, bool isUploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  isUploaded ? Icons.check_circle : Icons.error,
                  color: isUploaded ? Colors.green : Colors.orange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isUploaded ? "Uploaded" : "Pending",
                  style: TextStyle(
                    color: isUploaded ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryOrange,
                    side: BorderSide(color: AppColors.primaryOrange),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Previous"),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _currentStep == 2
                    ? _submitForm
                    : () {
                        setState(() {
                          _currentStep++;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(_currentStep == 2 ? "Submit" : "Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    int maxLines = 1,
    int maxLength = 10,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {});
        },
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: '',
            hintText: isRequired ? "$label *" : label,
            // labelText: isRequired ? "$label *" : label,
            prefixIcon: Icon(icon, color: AppColors.primaryOrange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentModeToggle() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleOption("eNACH", paymentMode == "eNACH")),
          const SizedBox(width: 8),
          Expanded(
            child: _buildToggleOption("UPI Autopay", paymentMode == "UPI"),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          paymentMode = text == "eNACH" ? "eNACH" : "UPI";
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildENACHFields() {
    return Column(
      children: [
        _buildAnimatedField(
          controller: bankName,
          label: "Bank Name",
          icon: Icons.account_balance,
          isRequired: true,
          maxLength: 200,
        ),
        _buildAnimatedField(
          controller: accountholderName,
          label: "Account Holder Name",
          icon: Icons.person,
          isRequired: true,
          maxLength: 200,
        ),
        _buildAnimatedField(
          controller: accountNumber,
          label: "Account Number",
          icon: Icons.numbers,
          keyboardType: TextInputType.number,
          isRequired: true,
        ),
        _buildAnimatedField(
          controller: ifscCode,
          label: "IFSC Code",
          icon: Icons.code,
          isRequired: true,
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildUPIFields() {
    return _buildAnimatedField(
      controller: upiIdController,
      label: "UPI ID",
      icon: Icons.payment,
      isRequired: true,
      maxLength: 500,
    );
  }

  Widget _buildFrequencySelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: frequancy.text.isNotEmpty ? frequancy.text : null,
          hint: const Text("Select Frequency *"),
          items: const ["WEEKLY", "BI-WEEKLY", "MONTHLY"].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              frequancy.text = value ?? "";
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.update,
              color: AppColors.primaryOrange,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _showDurationSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: AppColors.primaryOrange),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Installment Duration *",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      intallment_duration.text.isEmpty
                          ? "Select duration"
                          : "${intallment_duration.text} months",
                      style: TextStyle(
                        fontSize: 16,
                        color: intallment_duration.text.isEmpty
                            ? Colors.grey.shade400
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              controller: startdate,
              label: "Start Date",
              icon: Icons.calendar_today,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDateField(
              controller: enddate,
              label: "End Date",
              icon: Icons.calendar_today,
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return InkWell(
      onTap: readOnly ? null : () => _selectDate(controller),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty ? "Select" : controller.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.text.isEmpty
                          ? Colors.grey.shade400
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImeiField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 15,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.qr_code, color: AppColors.primaryOrange),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => scanImei(controller),
            color: AppColors.primaryOrange,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          counterText: "",
        ),
      ),
    );
  }

  Widget _buildDocumentUploader({
    required String title,
    required IconData icon,
    File? file,
    required Function(File) onTap, // This should be Function(File) not dynamic
  }) {
    return InkWell(
      onTap: () async {
        File? pickedFile = await openFilePicker(context);
        if (pickedFile != null) {
          onTap(pickedFile);
          setState(() {});
        }
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: file != null ? Colors.green : Colors.grey.shade300,
            width: file != null ? 2 : 1,
          ),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(file, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryOrange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        if (controller == startdate) {
          _calculateEndDate();
        }
      });
    }
  }

  void _showDurationSheet() {
    List<int> durations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Duration",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemCount: durations.length,
                itemBuilder: (context, index) {
                  int duration = durations[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        intallment_duration.text = duration.toString();
                        _calculateEndDate();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: intallment_duration.text == duration.toString()
                            ? AppColors.primaryOrange
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$duration",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  intallment_duration.text ==
                                      duration.toString()
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            _emiText(duration),
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  intallment_duration.text ==
                                      duration.toString()
                                  ? Colors.white70
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    try {
      appLoader.show(context);

      final value = await AddCustomerApi().get(
        FullName: fullName.text,
        email: email.text,
        mobile: mobileNumber.text,
        bankName: bankName.text,
        accountNo: accountNumber.text,
        ifsc: ifscCode.text,
        accountHolderName: accountholderName.text,
        amount: amount.text,
        intallmentduration: intallment_duration.text,
        startDate: startdate.text,
        notes: notes.text,
        refName1: refName1.text,
        refmobile1: refMobile1.text,
        refName2: refName2.text,
        refmobile2: refMobile2.text,
        ram: ram.text,
        color: color.text,
        model: model.text,
        imeino1: imei_no1.text,
        imeino2: imei_no2.text,
        phoneType: phoneType.text,
        frequency: frequancy.text,
      );

      final customerId = value['data']['user']['id'].toString();
      await AppPrefrence.putString('id', customerId);

      _showSuccessToast(value['message'].toString());

      if (customerPhoto == null ||
          aadhaarFront == null ||
          aadhaarBack == null ||
          panCard == null ||
          mobileBill == null ||
          mobilePhoto == null) {
        appLoader.hide();
        _showErrorToast("Please upload all documents");
        return;
      }

      await uploadCustomerDocuments(
        customerPhoto: customerPhoto!,
        aadhaarFront: aadhaarFront!,
        aadhaarBack: aadhaarBack!,
        pan: panCard!,
        mobileBill: mobileBill!,
        mobileImage: mobilePhoto!,
      );

      _showSuccessToast("Documents uploaded successfully");

      final savedId = await AppPrefrence.getString('id');
      await PolicyApiService().createPolicy();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MandateStatusScreen(
              enterpriseId: "LC00ynkd6x",
              policyId: "policy51",
              customerId: savedId,
            ),
          ),
        );
      }

      appLoader.hide();
    } catch (e) {
      appLoader.hide();
      _showErrorToast(e.toString());
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
