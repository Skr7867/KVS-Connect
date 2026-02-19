class EmiPendingModel {
  bool success;
  EmiCompletedData data;

  EmiPendingModel({
    required this.success,
    required this.data,
  });

  factory EmiPendingModel.fromJson(Map<String, dynamic> json) {
    return EmiPendingModel(
      success: json['success'] ?? false,
      data: EmiCompletedData.fromJson(json['data'] ?? {}),
    );
  }
}

/* ================= DATA ================= */

class EmiCompletedData {
  List<Customer> customers;
  int total;
  int page;
  int limit;
  int totalPages;

  EmiCompletedData({
    required this.customers,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory EmiCompletedData.fromJson(Map<String, dynamic> json) {
    return EmiCompletedData(
      customers: (json['customers'] as List? ?? [])
          .map((e) => Customer.fromJson(e))
          .toList(),
      total: int.tryParse(json['total']?.toString() ?? "") ?? 0,
      page: int.tryParse(json['page']?.toString() ?? "") ?? 0,
      limit: int.tryParse(json['limit']?.toString() ?? "") ?? 0,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? "") ?? 0,
    );
  }
}

/* ================= CUSTOMER ================= */

class Customer {
  String id;
  String customerId;
  String fullName;
  String mobile;
  String email;
  String bankName;
  String accountNo;
  String ifscCode;
  String accountHolderName;
  double mandateAmount;
  int installmentDuration;
  String kycStatus;
  User user;
  final PhoneDetails phoneDetails;
  EmiSummary emiSummary;

  Customer({
    required this.id,
    required this.customerId,
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.accountHolderName,
    required this.mandateAmount,
    required this.installmentDuration,
    required this.kycStatus,
    required this.user,
    required this.emiSummary,
    required this.phoneDetails,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? "",
      customerId: json['customer_id'] ?? "",
      fullName: json['full_name'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
      bankName: json['bank_name'] ?? "",
      accountNo: json['account_no'] ?? "",
      ifscCode: json['ifsc_code'] ?? "",
      accountHolderName: json['account_holder_name'] ?? "",
      mandateAmount:
      double.tryParse(json['mandate_amount']?.toString() ?? "") ?? 0.0,
      installmentDuration:
      int.tryParse(json['installment_duration']?.toString() ?? "") ?? 0,
      kycStatus: json['kyc_status'] ?? "",
      user: User.fromJson(json['user_id'] ?? {}),
      emiSummary: EmiSummary.fromJson(json['emi_summary'] ?? {}),
      phoneDetails: json['phone_details'] != null
          ? PhoneDetails.fromJson(json['phone_details'])
          : PhoneDetails.empty(),
    );
  }
}

/* ================= USER ================= */

class User {
  String id;
  String name;
  String mobile;
  String email;
  String accountStatus;
  String accountStage;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.accountStatus,
    required this.accountStage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
      accountStatus: json['account_status'] ?? "",
      accountStage: json['account_stage'] ?? "",
    );
  }
}

/* ================= EMI SUMMARY ================= */

class EmiSummary {
  String emiId;
  String status;
  int totalAmount;
  int totalTenure;
  int paidTenure;
  int unpaidTenure;
  String paidInstallments;
  int outstandingAmount;
  int totalPaid;
  int totalPenalty;
  String nextDueDate;

  EmiSummary({
    required this.emiId,
    required this.status,
    required this.totalAmount,
    required this.totalTenure,
    required this.paidTenure,
    required this.unpaidTenure,
    required this.paidInstallments,
    required this.outstandingAmount,
    required this.totalPaid,
    required this.totalPenalty,
    required this.nextDueDate,
  });

  factory EmiSummary.fromJson(Map<String, dynamic> json) {
    return EmiSummary(
      emiId: json['emi_id'] ?? "",
      status: json['status'] ?? "",
      totalAmount:
      int.tryParse(json['total_amount']?.toString() ?? "") ?? 0,
      totalTenure:
      int.tryParse(json['total_tenure']?.toString() ?? "") ?? 0,
      paidTenure:
      int.tryParse(json['paid_tenure']?.toString() ?? "") ?? 0,
      unpaidTenure:
      int.tryParse(json['unpaid_tenure']?.toString() ?? "") ?? 0,
      paidInstallments: json['paid_installments'] ?? "",
      outstandingAmount:
      int.tryParse(json['outstanding_amount']?.toString() ?? "") ?? 0,
      totalPaid:
      int.tryParse(json['total_paid']?.toString() ?? "") ?? 0,
      totalPenalty:
      int.tryParse(json['total_penalty']?.toString() ?? "") ?? 0,
      nextDueDate: json['next_due_date'] ?? "",
    );
  }
}
class PhoneDetails {
  final String displayName;
  PhoneDetails({required this.displayName});

  factory PhoneDetails.fromJson(Map<String, dynamic> json) =>
      PhoneDetails(displayName: json['display_name'] ?? '');

  factory PhoneDetails.empty() => PhoneDetails(displayName: '');
}
