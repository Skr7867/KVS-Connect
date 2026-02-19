import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeemilocker/api/Retailer_Api/my_bank_details_Api/my_bank_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../text_style/app_text_styles.dart';
import '../text_style/colors.dart';
import '../widgets/custom_loader.dart';


class MyBankDetails extends StatefulWidget {
  const MyBankDetails({super.key});

  @override
  State<MyBankDetails> createState() => _MyBankDetailsState();
}

class _MyBankDetailsState extends State<MyBankDetails> {

  TextEditingController   bankName = TextEditingController();
  TextEditingController   accountholderName = TextEditingController();
  TextEditingController   accountNumber = TextEditingController();
  TextEditingController   ifscCode = TextEditingController();
  TextEditingController branchName = TextEditingController();

 @override
 void initState() {
   super.initState();
   loadBankData();
 }

 Future<void> loadBankData() async {
   final prefs = await SharedPreferences.getInstance();

   bankName.text = prefs.getString('bankName') ?? "";
   accountholderName.text = prefs.getString('accountholderName') ?? "";
   accountNumber.text = prefs.getString('accountNumber') ?? "";
   branchName.text = prefs.getString('branchName') ?? "";
   ifscCode.text = prefs.getString('ifsc') ?? "";
 }
  Future<void> saveBankData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('bankName', bankName.text);
    await prefs.setString('accountholderName', accountholderName.text);
    await prefs.setString('branchName', branchName.text);
    await prefs.setString('accountNumber', accountNumber.text);
    await prefs.setString('ifsc', ifscCode.text);
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            _sectionTitle(Icons.person, "Bank Details"),
            _input(label: "Bank Name *", hint: "Enter bank name",controller: bankName),
            _input(label: "Account Holder *",hint:  "Enter account holder name",controller: accountholderName),
            _inputAmount(label: "Account No *",hint:  "Enter account number",controller: accountNumber),
            _input(label: "IFSC *", hint: "Enter IFSC code",controller: ifscCode),
            _input(label: "Branch Name *", hint: "Enter Branch Name",controller: branchName),
            SizedBox(height: 30,),
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
                onPressed: () async{
                  try {
                    appLoader.show(context);
                    await saveBankData();
                    final value = await MyBankApi().get(
                      bankName: bankName.text,
                      accountNo: accountNumber.text,
                      ifsc: ifscCode.text,
                      accountHolderName: accountholderName.text, branchName: branchName.text,);
                    Fluttertoast.showToast(
                      msg: value['message'].toString(),
                    );
                    appLoader.hide();
                  } catch (e) {
                    appLoader.hide();
                    print("ERROR: $e");
                    Fluttertoast.showToast(msg: e.toString());
                  }},
        
        
                   child: Text(
                "Submit",
                style: AppTextStyles.heading16whitebold,
              ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
            ),
      ));
  }
  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryOrange),
          const SizedBox(width: 6),
          Text(title, style: AppTextStyles.heading16whiteboldColor1F2937),
        ],
      ),
    );
  }
  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _inputAmount({
   required String label,
   required String hint,
   required TextEditingController controller,
   TextInputType keyboardType = TextInputType.number,
   bool readOnly = false,
 }) {
   return Padding(
     padding: const EdgeInsets.only(bottom: 12),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(label, style: const TextStyle(fontSize: 12)),
         const SizedBox(height: 6),
         TextField(
           controller: controller,
           keyboardType: const TextInputType.numberWithOptions(
             decimal: true,
           ),
           readOnly: readOnly,
           decoration: InputDecoration(
             hintText: hint,
             hintStyle: TextStyle(color: AppColors.textHint),
             filled: true,
             fillColor: Colors.white,
             contentPadding: const EdgeInsets.symmetric(
               horizontal: 12,
               vertical: 14,
             ),
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(8),
               borderSide: BorderSide.none,
             ),
           ),
         ),
       ],
     ),
   );
 }

}
