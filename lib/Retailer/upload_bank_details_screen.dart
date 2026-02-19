import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Retailer/my_account_screen.dart';
import '../text_style/colors.dart';
import 'bank_details_api.dart';

class UploadBankDetailsScreen extends StatefulWidget {
  const UploadBankDetailsScreen({super.key});

  @override
  State<UploadBankDetailsScreen> createState() =>
      _UploadBankDetailsScreenState();
}

class _UploadBankDetailsScreenState extends State<UploadBankDetailsScreen> {
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final holderController = TextEditingController();
  final bankController = TextEditingController();
  final branchController = TextEditingController();

  bool isLoading = false;

  // Validation states
  bool isAccountValid = true;
  bool isIfscValid = true;
  bool isHolderValid = true;
  bool isBankValid = true;
  bool isBranchValid = true;

  String? accountError;
  String? ifscError;
  String? holderError;
  String? bankError;
  String? branchError;

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    // Add listeners for real-time validation
    accountController.addListener(() => _validateField('account'));
    ifscController.addListener(() => _validateField('ifsc'));
    holderController.addListener(() => _validateField('holder'));
    bankController.addListener(() => _validateField('bank'));
    branchController.addListener(() => _validateField('branch'));
  }

  @override
  void dispose() {
    accountController.removeListener(() => _validateField('account'));
    ifscController.removeListener(() => _validateField('ifsc'));
    holderController.removeListener(() => _validateField('holder'));
    bankController.removeListener(() => _validateField('bank'));
    branchController.removeListener(() => _validateField('branch'));

    accountController.dispose();
    ifscController.dispose();
    holderController.dispose();
    bankController.dispose();
    branchController.dispose();
    super.dispose();
  }

  /// 📝 LOAD SAVED DATA FROM SHARED PREFERENCES
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        accountController.text = prefs.getString('bank_account') ?? '';
        ifscController.text = prefs.getString('bank_ifsc') ?? '';
        holderController.text = prefs.getString('bank_holder') ?? '';
        bankController.text = prefs.getString('bank_name') ?? '';
        branchController.text = prefs.getString('bank_branch') ?? '';
      });
    } catch (e) {
      log("Error loading bank data: $e");
    }
  }

  /// 💾 SAVE DATA TO SHARED PREFERENCES
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('bank_account', accountController.text);
      await prefs.setString('bank_ifsc', ifscController.text);
      await prefs.setString('bank_holder', holderController.text);
      await prefs.setString('bank_name', bankController.text);
      await prefs.setString('bank_branch', branchController.text);

      log("✅ Bank details saved locally");
    } catch (e) {
      log("Error saving bank data: $e");
    }
  }

  /// 🔍 FIELD VALIDATION
  void _validateField(String field) {
    setState(() {
      switch (field) {
        case 'account':
          if (accountController.text.isNotEmpty &&
              accountController.text.length < 9) {
            isAccountValid = false;
            accountError = "Account number must be at least 9 digits";
          } else if (accountController.text.isNotEmpty &&
              !RegExp(r'^[0-9]+$').hasMatch(accountController.text)) {
            isAccountValid = false;
            accountError = "Account number should contain only digits";
          } else {
            isAccountValid = true;
            accountError = null;
          }
          break;

        case 'ifsc':
          final ifsc = ifscController.text.toUpperCase();
          if (ifsc.isNotEmpty &&
              !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
            isIfscValid = false;
            ifscError = "Invalid IFSC format (e.g., SBIN0123456)";
          } else {
            isIfscValid = true;
            ifscError = null;
          }
          break;

        case 'holder':
          if (holderController.text.isNotEmpty &&
              holderController.text.length < 3) {
            isHolderValid = false;
            holderError = "Name must be at least 3 characters";
          } else {
            isHolderValid = true;
            holderError = null;
          }
          break;

        case 'bank':
          if (bankController.text.isNotEmpty &&
              bankController.text.length < 2) {
            isBankValid = false;
            bankError = "Enter a valid bank name";
          } else {
            isBankValid = true;
            bankError = null;
          }
          break;

        case 'branch':
          if (branchController.text.isNotEmpty &&
              branchController.text.length < 2) {
            isBranchValid = false;
            branchError = "Enter a valid branch name";
          } else {
            isBranchValid = true;
            branchError = null;
          }
          break;
      }
    });
  }

  /// ✅ VALIDATION
  bool validate() {
    bool isValid = true;

    // Validate account number
    if (accountController.text.trim().isEmpty) {
      showSnack("Enter Account Number");
      isValid = false;
    } else if (accountController.text.length < 9) {
      showSnack("Account number must be at least 9 digits");
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(accountController.text)) {
      showSnack("Account number should contain only digits");
      isValid = false;
    }

    // Validate IFSC
    if (ifscController.text.trim().isEmpty) {
      showSnack("Enter IFSC Code");
      isValid = false;
    } else if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(ifscController.text.toUpperCase())) {
      showSnack("Invalid IFSC Code format");
      isValid = false;
    }

    // Validate holder name
    if (holderController.text.trim().isEmpty) {
      showSnack("Enter Account Holder Name");
      isValid = false;
    } else if (holderController.text.length < 3) {
      showSnack("Name must be at least 3 characters");
      isValid = false;
    }

    // Validate bank name
    if (bankController.text.trim().isEmpty) {
      showSnack("Enter Bank Name");
      isValid = false;
    }

    // Validate branch name
    if (branchController.text.trim().isEmpty) {
      showSnack("Enter Branch Name");
      isValid = false;
    }

    return isValid;
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// ✅ SUBMIT BANK DETAILS
  Future<void> submitBankDetails() async {
    if (!validate()) return;

    try {
      setState(() => isLoading = true);

      final api = BankDetailsApi();

      final result = await api.submitBankDetails(
        accountNumber: accountController.text.trim(),
        ifscCode: ifscController.text.trim().toUpperCase(),
        accountHolderName: holderController.text.trim(),
        bankName: bankController.text.trim(),
        branchName: branchController.text.trim(),
      );

      log("✅ FINAL BANK RESULT: $result");

      if (result["success"] == true) {
        // Clear saved data after successful submission
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('bank_account');
        await prefs.remove('bank_ifsc');
        await prefs.remove('bank_holder');
        await prefs.remove('bank_name');
        await prefs.remove('bank_branch');

        showSuccessSnack("Bank Details Submitted Successfully ✅");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyAccountScreen()),
          (route) => false,
        );
      } else {
        showSnack(result["message"] ?? "Submission Failed");
      }
    } catch (e) {
      log("❌ Submit Error: $e");
      showSnack("Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const BackButton(color: Colors.white),
        ),
        title: Text(
          'Bank Details',
          style: AppTextStyles.heading18whiteBold.copyWith(letterSpacing: 0.5),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(color: Colors.white.withOpacity(0.3), height: 1),
        ),
      ),
      body: Stack(
        children: [
          /// MAIN CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  /// Progress Indicator
                  _buildProgressIndicator(),

                  const SizedBox(height: 24),

                  /// Section Title with Description
                  _sectionTitle(
                    Icons.account_balance,
                    "Bank Account Details",
                    subtitle:
                        "Please provide your bank information for verification and payouts",
                  ),

                  const SizedBox(height: 20),

                  /// Account Details Card
                  Container(
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          /// Account Number Field
                          _buildFieldWithLabel(
                            label: "Account Number",
                            tooltip:
                                "Enter your bank account number (9-18 digits)",
                            isRequired: true,
                            controller: accountController,
                            icon: Icons.account_box_rounded,
                            // icon: I.account_box_rounded,
                            isValid: isAccountValid,
                            errorText: accountError,
                            keyboardType: TextInputType.number,
                            onChanged: () => _saveData(),
                          ),

                          const SizedBox(height: 16),

                          /// IFSC Code Field
                          _buildFieldWithLabel(
                            label: "IFSC Code",
                            tooltip:
                                "Enter 11-digit IFSC code (e.g., SBIN0123456)",
                            isRequired: true,
                            controller: ifscController,
                            icon: Icons.code,
                            isValid: isIfscValid,
                            errorText: ifscError,
                            textCapitalization: TextCapitalization.characters,
                            onChanged: () => _saveData(),
                          ),

                          const SizedBox(height: 16),

                          /// Account Holder Name Field
                          _buildFieldWithLabel(
                            label: "Account Holder Name",
                            tooltip: "Enter name as per bank records",
                            isRequired: true,
                            controller: holderController,
                            icon: Icons.person,
                            isValid: isHolderValid,
                            errorText: holderError,
                            onChanged: () => _saveData(),
                          ),

                          const SizedBox(height: 16),

                          /// Bank Name Field
                          _buildFieldWithLabel(
                            label: "Bank Name",
                            tooltip: "Enter your bank name",
                            isRequired: true,
                            controller: bankController,
                            icon: Icons.account_balance,
                            isValid: isBankValid,
                            errorText: bankError,
                            onChanged: () => _saveData(),
                          ),

                          const SizedBox(height: 16),

                          /// Branch Name Field
                          _buildFieldWithLabel(
                            label: "Branch Name",
                            tooltip: "Enter your bank branch",
                            isRequired: true,
                            controller: branchController,
                            icon: Icons.home,
                            isValid: isBranchValid,
                            errorText: branchError,
                            onChanged: () => _saveData(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Information Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Important Information",
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Ensure all details match your bank records. Incorrect information may delay payouts.",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Submit Button
                  _buildSubmitButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          /// LOADER OVERLAY
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange,
                        ),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Submitting Bank Details...",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 🎯 ENHANCED WIDGETS

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProgressStep(1, "PAN", true),
          _buildProgressStep(2, "GST", true),
          _buildProgressStep(3, "Bank", true),
          _buildProgressStep(4, "Review", false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primaryOrange
                    : Colors.grey.shade300,
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryOrange
                    : Colors.grey.shade400,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWithLabel({
    required String label,
    required String tooltip,
    required bool isRequired,
    required TextEditingController controller,
    required IconData icon,
    required bool isValid,
    String? errorText,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                "*",
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Tooltip(
              message: tooltip,
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          onChanged: (_) => onChanged(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: "Enter ${label.toLowerCase()}",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                icon,
                color: isValid ? AppColors.primaryOrange : Colors.red,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isValid ? Colors.grey.shade200 : Colors.red.shade200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryOrange,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        if (errorText != null && !isValid) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade600, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.BtnGreenBg,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.BtnGreenBg.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isLoading ? null : submitBankDetails,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 20),
            const SizedBox(width: 8),
            Text(
              "Submit Bank Details",
              style: AppTextStyles.heading16whitebold.copyWith(
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primaryOrange),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
