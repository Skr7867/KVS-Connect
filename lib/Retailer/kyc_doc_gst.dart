import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/Retailer_Api/kyc_doc_api/kyc_api.dart';
import '../api/Retailer_Api/kyc_doc_api/kyc_url_api.dart';
import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';
import '../widgets/file_picker.dart';
import 's3_upload_file.dart';
import 'upload_bank_details_screen.dart';

class KycDocGst extends StatefulWidget {
  const KycDocGst({super.key});

  @override
  State<KycDocGst> createState() => _KycDocGstState();
}

class _KycDocGstState extends State<KycDocGst> {
  File? gstFile;
  TextEditingController gstNumber = TextEditingController();

  bool isLoading = false;
  bool isGstValid = true;
  String? gstError;

  @override
  void initState() {
    super.initState();
    loadKycData();
    gstNumber.addListener(_validateGstOnChange);
  }

  @override
  void dispose() {
    gstNumber.removeListener(_validateGstOnChange);
    gstNumber.dispose();
    super.dispose();
  }

  void _validateGstOnChange() {
    final gst = gstNumber.text.trim().toUpperCase();
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    setState(() {
      if (gst.isNotEmpty && !gstRegex.hasMatch(gst)) {
        isGstValid = false;
        gstError = "Invalid GST format";
      } else {
        isGstValid = true;
        gstError = null;
      }
    });
  }

  /// ---------------- CONTENT TYPE ----------------
  String getContentType(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith(".png")) return "image/png";
    if (lower.endsWith(".jpg")) return "image/jpeg";
    if (lower.endsWith(".jpeg")) return "image/jpeg";
    if (lower.endsWith(".pdf")) return "application/pdf";

    return "image/jpeg";
  }

  /// ---------------- VALIDATION ----------------
  bool _validateGstData() {
    final gst = gstNumber.text.trim().toUpperCase();

    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    if (gst.isEmpty) {
      _showSnack("Please enter GST number");
      return false;
    }

    if (!gstRegex.hasMatch(gst)) {
      _showSnack("Invalid GST format");
      return false;
    }

    if (gstFile == null) {
      _showSnack("Please upload GST document");
      return false;
    }

    if (gstFile!.lengthSync() > 5 * 1024 * 1024) {
      _showSnack("GST file must be less than 5MB");
      return false;
    }

    return true;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
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

  /// ---------------- LOAD LOCAL DATA ----------------
  Future<void> loadKycData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('panNumber', gstNumber.text);

    String? gstPath = prefs.getString('gstImage');

    if (gstPath != null && gstPath.isNotEmpty) {
      gstFile = File(gstPath);
    }

    setState(() {});
  }

  Future<void> saveKycData() async {
    final prefs = await SharedPreferences.getInstance();

    if (gstFile != null) {
      await prefs.setString('gstImage', gstFile!.path);
    }
  }

  /// ---------------- GST UPLOAD FLOW ----------------
  Future<bool> uploadGstFlow() async {
    if (!_validateGstData()) return false;

    try {
      final api = KycUrlApi();

      final fileName = gstFile!.path.split("/").last;
      final contentType = getContentType(fileName);
      final fileSize = gstFile!.lengthSync();

      /// STEP 1 — Get Presigned URL
      final resp = await api.getUploadUrl(
        docType: "GST",
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

      /// STEP 2 — Upload File To S3
      final uploaded = await S3UploadService.uploadFileToS3(
        uploadUrl: uploadUrl,
        file: gstFile!,
        contentType: contentType,
      );

      if (!uploaded) {
        _showSnack("GST Upload Failed");
        return false;
      }

      /// STEP 3 — Submit GST Details To Backend
      final result = await GstDocumentsApi().uploadBusinessDocuments(
        gstDetails: {
          "gstNumber": gstNumber.text.trim().toUpperCase(),
          "s3Key": s3Key,
          "fileSize": fileSize,
          "contentType": contentType,
        },
      );

      if (result["success"] != true) {
        _showSnack(result["message"] ?? "GST Submission Failed");
        return false;
      }

      return true;
    } catch (e) {
      log("GST Upload Error: $e");
      _showSnack("GST Upload Error");
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
                    Icons.assignment_turned_in,
                    "GST Details",
                    subtitle:
                        "Please provide your GST information for verification",
                  ),

                  const SizedBox(height: 20),

                  /// GST Number Input Card
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
                            "GST Number",
                            "Enter your 15-digit GST number",
                            isRequired: true,
                          ),
                          const SizedBox(height: 8),
                          _buildGSTInputField(),
                          if (!isGstValid && gstError != null) ...[
                            const SizedBox(height: 8),
                            _buildErrorText(gstError!),
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
                            "Upload GST Document",
                            "Upload scanned copy of your GST certificate (Max 5MB, PDF/JPEG/PNG)",
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          _buildEnhancedUploadBox(),
                          if (gstFile != null) ...[
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
                        "Uploading GST Details...",
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
          _buildProgressStep(1, "Personal", true),
          _buildProgressStep(2, "GST", true),
          _buildProgressStep(3, "Bank", false),
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

  Widget _buildGSTInputField() {
    return TextFormField(
      controller: gstNumber,
      textCapitalization: TextCapitalization.characters,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        hintText: "22AAAAA0000A1Z5",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.numbers,
            color: isGstValid ? AppColors.primaryOrange : Colors.red,
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
            color: isGstValid ? Colors.grey.shade200 : Colors.red.shade200,
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
          setState(() => gstFile = file);
          saveKycData();
        }
      },
      child: Container(
        height: gstFile != null ? 180 : 140,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
          border: Border.all(
            color: gstFile != null
                ? AppColors.primaryOrange.withOpacity(0.3)
                : Colors.grey.shade300,
            width: gstFile != null ? 2 : 1,
            style: gstFile != null ? BorderStyle.solid : BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (gstFile != null)
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: gstFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(gstFile!, fit: BoxFit.cover),
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
                            setState(() => gstFile = null);
                          },
                          color: Colors.red,
                          padding: const .all(4),
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
                              "Uploaded",
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
                    "Tap to upload GST document",
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
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.green.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gstFile!.path.split("/").last,
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${(gstFile!.lengthSync() / 1024).toStringAsFixed(2)} KB",
                  style: TextStyle(color: Colors.green.shade600, fontSize: 11),
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
                final success = await uploadGstFlow();
                setState(() => isLoading = false);

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UploadBankDetailsScreen(),
                    ),
                  );
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, size: 20),
            const SizedBox(width: 8),
            Text(
              "Submit Documents",
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
