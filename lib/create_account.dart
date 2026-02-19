import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:safeemilocker/text_style/app_text_styles.dart';
import 'package:safeemilocker/text_style/colors.dart';
import 'package:safeemilocker/widgets/custom_loader.dart';
import 'package:safeemilocker/widgets/popup.dart';

import 'Retailer/home.dart';
import 'api/Retailer_Api/otp_verify/otp_verify_api.dart';
import 'api/Retailer_Api/register/register_api.dart';
import 'contants/user_storedata.dart';
import 'distibutor/home.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isRetailer = true;

  String selectedRole = "RETAILER";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // jitna round chahiye
                child: Image.asset(
                  'assets/image/KVSAppLogo.png',
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              Text("Create Account", style: AppTextStyles.heading24Boldblack),

              const SizedBox(height: 6),

              Text(
                "Welcome! Let's get you started.",
                style: AppTextStyles.body16w400Medium,
              ),

              const SizedBox(height: 30),

              /// Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("I am a", style: AppTextStyles.body14w500medium374151),

                    const SizedBox(height: 10),

                    /// Retailer / Distributor Toggle
                    Row(
                      children: [
                        // 🔸 Retailer
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isRetailer = true;
                                selectedRole = "RETAILER";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isRetailer
                                    ? AppColors.primaryOrange
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.store,
                                    color: isRetailer
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Retailer",
                                    style: TextStyle(
                                      color: isRetailer
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // 🔸 Distributor
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isRetailer = false;
                                selectedRole =
                                    "DISTRIBUTOR"; // backend spelling
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isRetailer
                                    ? AppColors.primaryOrange
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping,
                                    color: !isRetailer
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Distributor",
                                    style: TextStyle(
                                      color: !isRetailer
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Mobile Number
                    const Text("Mobile Number", style: TextStyle(fontSize: 14)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        //prefixText: "+91  ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "98765 43210",
                        hintStyle: TextStyle(color: AppColors.textHint),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Get OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.BtnGreenBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          appLoader.show(context);
                          /*String selectedRole =
                          isRetailer ? "RETAILER" : "DISTRIBUTER";*/
                          final resp = RegsiterUserApi().sendOtp(
                            mobileNumber: mobileNumberController.text.trim(),
                            role: selectedRole,
                          );

                          resp
                              .then((value) async {
                                appLoader.hide();

                                if (value['data']['otp'] != null) {
                                  final otp = value['data']['otp'].toString();

                                  /// 🔔 OTP Toast
                                  Fluttertoast.showToast(
                                    msg: "Your OTP is $otp",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                  );

                                  /// ⬆️ Bottom Sheet Open
                                  showOtpBottomSheet(
                                    context,
                                    isRetailer,
                                    mobileNumberController.text.trim(),
                                  );
                                } else {
                                  showOtpBottomSheet(
                                    context,
                                    isRetailer,
                                    mobileNumberController.text.trim(),
                                  );
                                  Fluttertoast.showToast(
                                    msg:
                                        value['message'] ??
                                        "Something went wrong",
                                  );
                                }
                              })
                              .onError((error, stackTrace) {
                                appLoader.hide();
                                Fluttertoast.showToast(msg: error.toString());
                              });
                        },
                        /*Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpVerify(message:emailController.text)))*/
                        child: Text(
                          "Get OTP",
                          style: AppTextStyles.heading16w700white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Sign In
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.body14w400,
                  ),
                  Text(
                      "Sign In",
                      style: AppTextStyles.body14w400textColor046A38),

                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  /// ================= OTP BOTTOM SHEET =================
  showOtpBottomSheet(BuildContext context, bool isRetailer, String mobile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => OtpBottomSheet(isRetailer: isRetailer, mobile: mobile),
    );
  }
}

class OtpBottomSheet extends StatefulWidget {
  final bool isRetailer;
  final String mobile;

  const OtpBottomSheet({
    super.key,
    required this.isRetailer,
    required this.mobile,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController pinCodeTextController = TextEditingController();
  void handleSubmit(String otp) {
    if (otp.isEmpty) {
      showTost('Please enter OTP');
      return;
    }

    final role = widget.isRetailer ? "RETAILER" : "DISTRIBUTOR";

    appLoader.show(context);

    final resp = RegisterOtp().get(
      code: otp,
      mobileNumber: widget.mobile, // ✅ correct mobile
      role: role,
    );

    resp
        .then((value) async {
          appLoader.hide();

          final token = value['data']['token'];

          await AppPrefrence.putString("token", token);
          await AppPrefrence.getString('token');
          await AppPrefrence.putString("mobile", widget.mobile);
          await AppPrefrence.putString("role", role);
          await AppPrefrence.getString('role');
          if (widget.isRetailer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Home()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeDistibuter()),
            );
          }
        })
        .onError((error, stackTrace) {
          appLoader.hide();
          showTost('Incorrect OTP. Please try again.');
        });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const Text(
              "Verify OTP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            PinCodeTextField(
              length: 6,
              controller: pinCodeTextController,
              appContext: context,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,

              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 52,
                fieldWidth: 45,
                activeColor: Colors.green,
                selectedColor: Colors.blue,
                inactiveColor: const Color(0xFFE5E7EB),
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              enableActiveFill: true,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.pop(context); // close bottom sheet
                  handleSubmit(pinCodeTextController.text);
                  /*if (widget.isRetailer) {
                    handleSubmit(pinCodeTextController.text);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => Home()),
                    );
                  } else {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeDistibuter()),
                    );*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.BtnGreenBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Verify OTP",
                  style: AppTextStyles.heading16w700white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(onPressed: () {}, child: const Text("Resend OTP")),
          ],
        ),
      ),
    );
  }
}
