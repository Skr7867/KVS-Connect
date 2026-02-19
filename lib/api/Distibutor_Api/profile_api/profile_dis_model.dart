class ProfileResponseModel {
  final bool success;
  final ProfileData data;

  ProfileResponseModel({
    required this.success,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.toJson(),
    };
  }
}

// ================= MAIN DATA =================

class ProfileData {
  final Profile profile;
  final ContactInformation contactInformation;
  final BusinessInformation businessInformation;

  ProfileData({
    required this.profile,
    required this.contactInformation,
    required this.businessInformation,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      contactInformation:
      ContactInformation.fromJson(json['contact_information'] ?? {}),
      businessInformation:
      BusinessInformation.fromJson(json['business_information'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile": profile.toJson(),
      "contact_information": contactInformation.toJson(),
      "business_information": businessInformation.toJson(),
    };
  }
}

// ================= PROFILE =================

class Profile {
  final String name;
  final String distributorId;
  final String role;
  final String lastLogin;
  final String kycStatus;
  final String accountStatus;
  final String accountStage;

  Profile({
    required this.name,
    required this.distributorId,
    required this.role,
    required this.lastLogin,
    required this.kycStatus,
    required this.accountStatus,
    required this.accountStage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? "",
      distributorId: json['distributor_id'] ?? "",
      role: json['role'] ?? "",
      lastLogin: json['last_login'] ?? "",
      kycStatus: json['kyc_status'] ?? "",
      accountStatus: json['account_status'] ?? "",
      accountStage: json['account_stage'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "distributor_id": distributorId,
      "role": role,
      "last_login": lastLogin,
      "kyc_status": kycStatus,
      "account_status": accountStatus,
      "account_stage": accountStage,
    };
  }
}

// ================= CONTACT INFO =================

class ContactInformation {
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final int pincode;

  ContactInformation({
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory ContactInformation.fromJson(Map<String, dynamic> json) {
    return ContactInformation(
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      pincode: int.tryParse(json['pincode']?.toString() ?? "") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "email": email,
      "address": address,
      "city": city,
      "state": state,
      "pincode": pincode,
    };
  }
}

// ================= BUSINESS INFO =================

class BusinessInformation {
  final String companyName;
  final String businessType;
  final String currentPlan;

  BusinessInformation({
    required this.companyName,
    required this.businessType,
    required this.currentPlan,
  });

  factory BusinessInformation.fromJson(Map<String, dynamic> json) {
    return BusinessInformation(
      companyName: json['company_name'] ?? "",
      businessType: json['business_type'] ?? "",
      currentPlan: json['current_plan']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company_name": companyName,
      "business_type": businessType,
      "current_plan": currentPlan,
    };
  }
}
