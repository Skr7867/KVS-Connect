// ================== PARSE INT HELPER ==================
int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// ================== MAIN MODEL ==================
class RetailerProfileModel {
  final bool success;
  final RetailerData data;

  RetailerProfileModel({
    required this.success,
    required this.data,
  });

  factory RetailerProfileModel.fromJson(Map<String, dynamic> json) {
    return RetailerProfileModel(
      success: json['success'] ?? false,
      data: RetailerData.fromJson(json['data'] ?? {}),
    );
  }
}

// ================== DATA ==================
class RetailerData {
  final Profile profile;
  final KeyMetrics keyMetrics;
  final PersonalDetails personalDetails;
  final ShopDetails shopDetails;

  RetailerData({
    required this.profile,
    required this.keyMetrics,
    required this.personalDetails,
    required this.shopDetails,
  });

  factory RetailerData.fromJson(Map<String, dynamic> json) {
    return RetailerData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      keyMetrics: KeyMetrics.fromJson(json['key_metrics'] ?? {}),
      personalDetails:
      PersonalDetails.fromJson(json['personal_details'] ?? {}),
      shopDetails: ShopDetails.fromJson(json['shop_details'] ?? {}),
    );
  }
}

// ================== PROFILE ==================
class Profile {
  final String name;
  final String retailerId;
  final String role;
  final String lastLogin;
  final String kycStatus;
  final String accountStatus;
  final String accountStage;

  Profile({
    required this.name,
    required this.retailerId,
    required this.role,
    required this.lastLogin,
    required this.kycStatus,
    required this.accountStatus,
    required this.accountStage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? "",
      retailerId: json['retailer_id'] ?? "",
      role: json['role'] ?? "",
      lastLogin: json['last_login'] ?? "",
      kycStatus: json['kyc_status'] ?? "",
      accountStatus: json['account_status'] ?? "",
      accountStage: json['account_stage'] ?? "",
    );
  }
}

// ================== KEY METRICS ==================
class KeyMetrics {
  final int availableKeys;
  final int walletBalance;
  final int pendingDues;

  KeyMetrics({
    required this.availableKeys,
    required this.walletBalance,
    required this.pendingDues,
  });

  factory KeyMetrics.fromJson(Map<String, dynamic> json) {
    return KeyMetrics(
      availableKeys: parseInt(json['available_keys']),
      walletBalance: parseInt(json['wallet_balance']),
      pendingDues: parseInt(json['pending_dues']),
    );
  }
}

// ================== PERSONAL DETAILS ==================
class PersonalDetails {
  final String name;
  final String phone;
  final String email;
  final String address;

  PersonalDetails({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory PersonalDetails.fromJson(Map<String, dynamic> json) {
    return PersonalDetails(
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
    );
  }
}

// ================== SHOP DETAILS ==================
class ShopDetails {
  final String shopName;
  final String state;
  final String city;
  final String pincode;
  final String shopAddress;

  ShopDetails({
    required this.shopName,
    required this.state,
    required this.city,
    required this.pincode,
    required this.shopAddress,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    return ShopDetails(
      shopName: json['shop_name'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      pincode: json['pincode'] ?? "",
      shopAddress: json['shop_address'] ?? "",
    );
  }
}
