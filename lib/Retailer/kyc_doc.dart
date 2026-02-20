import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safeemilocker/Retailer/kyc_doc_gst.dart';
import 'package:safeemilocker/Retailer/s3_upload_file.dart'
    show S3UploadService;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/Retailer_Api/kyc_doc_api/kyc_api.dart';
import '../api/Retailer_Api/kyc_doc_api/kyc_url_api.dart';
import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';
import '../widgets/file_picker.dart';

class KycDoc extends StatefulWidget {
  const KycDoc({super.key});

  @override
  State<KycDoc> createState() => _KycDocState();
}

class _KycDocState extends State<KycDoc> {
  File? panCard;
  TextEditingController panNumber = TextEditingController();

  bool isLoading = false;
  bool isPanValid = true;
  String? panError;

  @override
  void initState() {
    super.initState();
    loadKycData();
    panNumber.addListener(_validatePanOnChange);
  }

  @override
  void dispose() {
    panNumber.removeListener(_validatePanOnChange);
    panNumber.dispose();
    super.dispose();
  }

  void _validatePanOnChange() {
    final pan = panNumber.text.trim().toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    setState(() {
      if (pan.isNotEmpty && !panRegex.hasMatch(pan)) {
        isPanValid = false;
        panError = "Invalid PAN format (e.g., ABCDE1234F)";
      } else {
        isPanValid = true;
        panError = null;
      }
    });
  }

  /// ---------------- CONTENT TYPE ----------------
  String getContentType(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith(".png")) return "image/png";
    if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
    if (lower.endsWith(".pdf")) return "application/pdf";

    return "image/jpeg";
  }

  /// ---------------- VALIDATION ----------------
  bool _validatePanData() {
    final pan = panNumber.text.trim().toUpperCase();

    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (pan.isEmpty) {
      _showSnack("Please enter PAN number");
      return false;
    }

    if (!panRegex.hasMatch(pan)) {
      _showSnack("Invalid PAN format (ABCDE1234F)");
      return false;
    }

    if (panCard == null) {
      _showSnack("Please upload PAN card");
      return false;
    }

    if (panCard!.lengthSync() > 5 * 1024 * 1024) {
      _showSnack("File must be less than 5MB");
      return false;
    }

    return true;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// ---------------- LOCAL SAVE ----------------
  Future<void> loadKycData() async {
    final prefs = await SharedPreferences.getInstance();

    panNumber.text = prefs.getString('panNumber') ?? "";

    String? panPath = prefs.getString('panImage');
    if (panPath != null && panPath.isNotEmpty) {
      panCard = File(panPath);
    }

    setState(() {});
  }

  Future<void> saveKycData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('panNumber', panNumber.text);

    if (panCard != null) {
      await prefs.setString('panImage', panCard!.path);
    }
  }

  /// ---------------- PAN UPLOAD FLOW ----------------
  Future<bool> uploadPanFlow() async {
    if (!_validatePanData()) return false;

    try {
      final api = KycUrlApi();

      final fileName = panCard!.path.split("/").last;
      final contentType = getContentType(fileName);
      final fileSize = panCard!.lengthSync();

      /// STEP 1 → GET PRESIGNED URL
      final resp = await api.getUploadUrl(
        docType: "PAN",
        fileName: fileName,
        contentType: contentType,
        fileSize: fileSize.toString(),
      );

      if (resp["success"] != true) {
        _showSnack("Upload URL generation failed");
        return false;
      }

      final uploadUrl = resp["data"]["uploadUrl"];
      final s3Key = resp["data"]["key"];

      /// STEP 2 → UPLOAD TO S3
      final uploaded = await S3UploadService.uploadFileToS3(
        uploadUrl: uploadUrl,
        file: panCard!,
        contentType: contentType,
      );

      if (!uploaded) {
        _showSnack("PAN Upload Failed");
        return false;
      }

      /// STEP 3 → SUBMIT TO BACKEND
      final result = await PanDocumentsApi().uploadBusinessDocuments(
        panDetails: {
          "panNumber": panNumber.text.trim().toUpperCase(),
          "s3Key": s3Key,
          "fileSize": fileSize,
          "contentType": contentType,
        },
      );

      if (result["success"] != true) {
        _showSnack(result["message"] ?? "PAN Submission Failed");
        return false;
      }

      return true;
    } catch (e) {
      _showSnack("Upload error occurred");
      return false;
    }
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
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
          "KYC Verification",
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
                    Icons.assignment_ind,
                    "PAN Card Details",
                    subtitle:
                        "Please provide your PAN information for verification",
                  ),

                  const SizedBox(height: 20),

                  /// PAN Number Input Card
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithTooltip(
                            "PAN Number",
                            "Enter your 10-digit PAN number (e.g., ABCDE1234F)",
                            isRequired: true,
                          ),
                          const SizedBox(height: 8),
                          _buildPANInputField(),
                          if (!isPanValid && panError != null) ...[
                            const SizedBox(height: 8),
                            _buildErrorText(panError!),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Document Upload Card
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithTooltip(
                            "Upload PAN Card",
                            "Upload scanned copy of your PAN card (Max 5MB, PDF/JPEG/PNG)",
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          _buildEnhancedUploadBox(),
                          if (panCard != null) ...[
                            const SizedBox(height: 12),
                            _buildFileInfo(),
                          ],
                        ],
                      ),
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
                        "Uploading PAN Details...",
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

  /// ---------------- ENHANCED WIDGETS ----------------

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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => KycDocGst()),
              );
            },
            child: _buildProgressStep(2, "GST", false),
          ),
          _buildProgressStep(3, "Bank", false),
          // _buildProgressStep(4, "Review", false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Expanded(
      child: Container(
        width: 70,
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

  Widget _buildLabelWithTooltip(
    String label,
    String tooltip, {
    bool isRequired = false,
  }) {
    return Row(
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
    );
  }

  Widget _buildPANInputField() {
    return TextFormField(
      controller: panNumber,
      textCapitalization: TextCapitalization.characters,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        hintText: "ABCDE1234F",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.badge,
            color: isPanValid ? AppColors.primaryOrange : Colors.red,
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
            color: isPanValid ? Colors.grey.shade200 : Colors.red.shade200,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade600, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            error,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedUploadBox() {
    return InkWell(
      onTap: () async {
        File? file = await openFilePicker(context);
        if (file != null) {
          setState(() => panCard = file);
          saveKycData();
        }
      },
      child: Container(
        height: panCard != null ? 180 : 140,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
          border: Border.all(
            color: panCard != null
                ? AppColors.primaryOrange.withOpacity(0.3)
                : Colors.grey.shade300,
            width: panCard != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (panCard != null)
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: panCard != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(panCard!, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            setState(() => panCard = null);
                          },
                          color: Colors.red,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "PAN Card Uploaded",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to upload PAN Card",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "PDF, JPEG or PNG (Max 5MB)",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFileInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.blue.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  panCard!.path.split("/").last,
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${(panCard!.lengthSync() / 1024).toStringAsFixed(2)} KB",
                  style: TextStyle(color: Colors.blue.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
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
        onPressed: isLoading
            ? null
            : () async {
                setState(() => isLoading = true);
                await saveKycData();
                final success = await uploadPanFlow();
                setState(() => isLoading = false);

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => KycDocGst()),
                  );
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, size: 20),
            const SizedBox(width: 8),
            Text(
              "Continue to GST Details",
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
