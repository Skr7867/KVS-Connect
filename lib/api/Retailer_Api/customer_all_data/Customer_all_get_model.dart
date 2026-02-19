// get_all_customers_model.dart

class GetAllCustomers {
  final bool success;
  final CustomerData? data;

  GetAllCustomers({required this.success, this.data});

  factory GetAllCustomers.fromJson(Map<String, dynamic> json) {
    return GetAllCustomers(
      success: json['success'] ?? false,
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
    );
  }
}

// ------------------------------------------------------

class CustomerData {
  final List<Customer> customers;
  final Summary? summary;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  CustomerData({
    required this.customers,
    this.summary,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customers: (json['customers'] as List<dynamic>? ?? [])
          .map((e) => Customer.fromJson(e))
          .toList(),
      summary:
      json['summary'] != null ? Summary.fromJson(json['summary']) : null,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      page: int.tryParse(json['page']?.toString() ?? '0') ?? 0,
      limit: int.tryParse(json['limit']?.toString() ?? '0') ?? 0,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
    );
  }
}

// ------------------------------------------------------

class Summary {
  final int totalCustomers;
  final int activeOnEmi;
  final int completed;
  final int overdue;

  Summary({
    required this.totalCustomers,
    required this.activeOnEmi,
    required this.completed,
    required this.overdue,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalCustomers:
      int.tryParse(json['total_customers']?.toString() ?? '0') ?? 0,
      activeOnEmi:
      int.tryParse(json['active_on_emi']?.toString() ?? '0') ?? 0,
      completed: int.tryParse(json['completed']?.toString() ?? '0') ?? 0,
      overdue: int.tryParse(json['overdue']?.toString() ?? '0') ?? 0,
    );
  }
}

// ------------------------------------------------------

class Customer {
  final String id;
  final User? user;
  final Retailer retailer;
  final String fullName;
  final String mobile;
  final String email;
  final String kycStatus;
  final int mandateAmount;
  final int installmentDuration;
  final int documentCount;
  final String customerId;
  final EmiSummary emiSummary;
  final PhoneDetails phoneDetails;
  final DeviceLockStatus deviceLockStatus;
  final AppLockStatus appLockStatus;
  final List<Document> documents;
  final List<Reference> references;
  final String? aadhaarNumber;

  Customer({
    required this.id,
    this.user,
    required this.retailer,
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.kycStatus,
    required this.mandateAmount,
    required this.installmentDuration,
    required this.documentCount,
    required this.customerId,
    required this.emiSummary,
    required this.phoneDetails,
    required this.deviceLockStatus,
    required this.appLockStatus,
    required this.documents,
    required this.references,
    this.aadhaarNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      user: json['user_id'] != null ? User.fromJson(json['user_id']) : null,

      retailer: json['retailer_id'] != null
          ? Retailer.fromJson(json['retailer_id'])
          : Retailer.empty(),

      fullName: json['full_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      kycStatus: json['kyc_status'] ?? '',
      mandateAmount:
      int.tryParse(json['mandate_amount']?.toString() ?? '0') ?? 0,
      installmentDuration:
      int.tryParse(json['installment_duration']?.toString() ?? '0') ?? 0,
      documentCount:
      int.tryParse(json['document_count']?.toString() ?? '0') ?? 0,
      customerId: json['customer_id'] ?? '',

      emiSummary: json['emi_summary'] != null
          ? EmiSummary.fromJson(json['emi_summary'])
          : EmiSummary.empty(),

      phoneDetails: json['phone_details'] != null
          ? PhoneDetails.fromJson(json['phone_details'])
          : PhoneDetails.empty(),

      deviceLockStatus: json['device_lock_status'] != null
          ? DeviceLockStatus.fromJson(json['device_lock_status'])
          : DeviceLockStatus.empty(),

      appLockStatus: json['app_lock_status'] != null
          ? AppLockStatus.fromJson(json['app_lock_status'])
          : AppLockStatus.empty(),

      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((e) => Document.fromJson(e))
          .toList(),

      references: (json['references'] as List<dynamic>? ?? [])
          .map((e) => Reference.fromJson(e))
          .toList(),

      aadhaarNumber: json['aadhaar_number'],
    );
  }
}

// ------------------------------------------------------

class User {
  final String id;
  final String role;
  final String parentId;
  final String name;
  final String mobile;
  final String email;
  final String accountStatus;
  final String accountStage;
  final int v;

  User({
    required this.id,
    required this.role,
    required this.parentId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.accountStatus,
    required this.accountStage,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      role: json['role'] ?? '',
      parentId: json['parent_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      accountStatus: json['account_status'] ?? '',
      accountStage: json['account_stage'] ?? '',
      v: int.tryParse(json['__v']?.toString() ?? '0') ?? 0,
    );
  }
}

class Retailer extends User {
  Retailer({
    required super.id,
    required super.role,
    required super.parentId,
    required super.name,
    required super.mobile,
    required super.email,
    required super.accountStatus,
    required super.accountStage,
    required super.v,
  });

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      id: json['_id'] ?? '',
      role: json['role'] ?? '',
      parentId: json['parent_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      accountStatus: json['account_status'] ?? '',
      accountStage: json['account_stage'] ?? '',
      v: int.tryParse(json['__v']?.toString() ?? '0') ?? 0,
    );
  }

  factory Retailer.empty() => Retailer(
    id: '',
    role: '',
    parentId: '',
    name: '',
    mobile: '',
    email: '',
    accountStatus: '',
    accountStage: '',
    v: 0,
  );
}

// ------------------------------------------------------

class EmiSummary {
  final String emiId;
  final String status;

  final int totalAmount;
  final int monthlyAmount;
  final int totalTenure;
  final int paidTenure;
  final int unpaidTenure;

  final String paidInstallments;

  final int outstandingAmount;
  final int totalPaid;
  final int totalPenalty;

  final String nextDueDate;
  final String startDate;
  final String endDate;

  EmiSummary({
    required this.emiId,
    required this.status,
    required this.totalAmount,
    required this.monthlyAmount,
    required this.totalTenure,
    required this.paidTenure,
    required this.unpaidTenure,
    required this.paidInstallments,
    required this.outstandingAmount,
    required this.totalPaid,
    required this.totalPenalty,
    required this.nextDueDate,
    required this.startDate,
    required this.endDate,
  });

  factory EmiSummary.fromJson(Map<String, dynamic> json) {
    return EmiSummary(
      emiId: json['emi_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',

      totalAmount: int.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      monthlyAmount:
      int.tryParse(json['monthly_amount']?.toString() ?? '0') ?? 0,
      totalTenure:
      int.tryParse(json['total_tenure']?.toString() ?? '0') ?? 0,
      paidTenure:
      int.tryParse(json['paid_tenure']?.toString() ?? '0') ?? 0,
      unpaidTenure:
      int.tryParse(json['unpaid_tenure']?.toString() ?? '0') ?? 0,

      paidInstallments:
      json['paid_installments']?.toString() ?? '',

      outstandingAmount:
      int.tryParse(json['outstanding_amount']?.toString() ?? '0') ?? 0,
      totalPaid:
      int.tryParse(json['total_paid']?.toString() ?? '0') ?? 0,
      totalPenalty:
      int.tryParse(json['total_penalty']?.toString() ?? '0') ?? 0,

      nextDueDate: json['next_due_date']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
    );
  }

  factory EmiSummary.empty() => EmiSummary(
    emiId: '',
    status: '',
    totalAmount: 0,
    monthlyAmount: 0,
    totalTenure: 0,
    paidTenure: 0,
    unpaidTenure: 0,
    paidInstallments: '',
    outstandingAmount: 0,
    totalPaid: 0,
    totalPenalty: 0,
    nextDueDate: '',
    startDate: '',
    endDate: '',
  );
}

class PhoneDetails {
  final String displayName;
  PhoneDetails({required this.displayName});

  factory PhoneDetails.fromJson(Map<String, dynamic> json) =>
      PhoneDetails(displayName: json['display_name'] ?? '');

  factory PhoneDetails.empty() => PhoneDetails(displayName: '');
}

class DeviceLockStatus {
  final String mobileLock;
  DeviceLockStatus({required this.mobileLock});

  factory DeviceLockStatus.fromJson(Map<String, dynamic> json) =>
      DeviceLockStatus(mobileLock: json['mobile_lock'] ?? '');

  factory DeviceLockStatus.empty() => DeviceLockStatus(mobileLock: '');
}

class AppLockStatus {
  final String whatsapp;
  AppLockStatus({required this.whatsapp});

  factory AppLockStatus.fromJson(Map<String, dynamic> json) =>
      AppLockStatus(whatsapp: json['whatsapp'] ?? '');

  factory AppLockStatus.empty() => AppLockStatus(whatsapp: '');
}

class Document {
  final String docType;
  final String filePath;

  Document({required this.docType, required this.filePath});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      docType: json['doc_type'] ?? '',
      filePath: json['file_path'] ?? '',
    );
  }
}

class Reference {
  final String name;
  final String mobile;

  Reference({required this.name, required this.mobile});

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      name: json['reference_name'] ?? '',
      mobile: json['reference_mobile'] ?? '',
    );
  }
}
