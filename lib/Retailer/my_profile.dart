import 'dart:developer';

import 'package:flutter/material.dart';

import '../api/Retailer_Api/profile_api/profile_api.dart';
import '../api/Retailer_Api/profile_api/profile_api_model.dart';
import '../widgets/custom_loader.dart';
import '../widgets/popup.dart';



class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  RetailerProfileModel? profiledata;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    appLoader.show(context);
    final rsp = ProfileApi().getProfile();
    rsp.then((value) {
      log(value.toString());
      try {
        setState(() {
          profiledata = value;
          print("Data show${profiledata.toString()}");
          // print("data show opposite gender${oppositegenderMataches}");
        });
        appLoader.hide();
      } catch (e) {
        setState(() {
          // loadingData = false;
        });
      }
    }).onError((error, stackTrace) {
      showTost(error);
      print(error);
      appLoader.hide();
    }).whenComplete(() {
      appLoader.hide();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          SizedBox(height: 100,),
          _sectionTitle("Personal & Shop Details"),
          _detailsCard(),
        ],
      ),),
    );
  }
  Widget _detailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children:  [
          _detailRow("Name", "${profiledata?.data?.personalDetails.name}"),
          _detailRow("Phone", "${profiledata?.data?.personalDetails.phone}"),
          _detailRow("Email", "${profiledata?.data?.personalDetails.email}"),
          _detailRow("Address", "${profiledata?.data?.personalDetails.address}"),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

}
class _detailRow extends StatelessWidget {
  final String label;
  final String value;

  const _detailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}