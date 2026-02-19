String parseString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

/* ================= RESPONSE ================= */

class RetailerResponseModel {
  final bool success;
  final List<Retailer> retailers;
  final RetailerSummary summary;
  final Pagination pagination;

  RetailerResponseModel({
    required this.success,
    required this.retailers,
    required this.summary,
    required this.pagination,
  });

  factory RetailerResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return RetailerResponseModel(
      success: json['success'] ?? false,
      retailers: (data['retailers'] as List? ?? [])
          .map((e) => Retailer.fromJson(e))
          .toList(),
      summary: RetailerSummary.fromJson(data['summary'] ?? {}),
      pagination: Pagination.fromJson(data['pagination'] ?? {}),
    );
  }
}

/* ================= RETAILER ================= */

class Retailer {
  final String id;
  final User user;
  final String shopName;
  final String ownerName;
  final String email;
  final String mobile;
  final String panNo;
  final String gstNo;
  final String state;
  final String city;
  final String pincode;
  final String shopAddress;
  final String kycStatus;
  final int documentCount;
  final String lastDocumentUpload;
  final String lastDocumentUpdate;
  final String createdAt;
  final String updatedAt;
  final int v;

  Retailer({
    required this.id,
    required this.user,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.mobile,
    required this.panNo,
    required this.gstNo,
    required this.state,
    required this.city,
    required this.pincode,
    required this.shopAddress,
    required this.kycStatus,
    required this.documentCount,
    required this.lastDocumentUpload,
    required this.lastDocumentUpdate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      id: parseString(json['_id']),
      user: User.fromJson(json['user_id'] ?? {}),
      shopName: parseString(json['shop_name']),
      ownerName: parseString(json['owner_name']),
      email: parseString(json['email']),
      mobile: parseString(json['mobile']),
      panNo: parseString(json['pan_no']),
      gstNo: parseString(json['gst_no']),
      state: parseString(json['state']),
      city: parseString(json['city']),
      pincode: parseString(json['pincode']),
      shopAddress: parseString(json['shop_address']),
      kycStatus: parseString(json['kyc_status']),
      documentCount: json['document_count'] ?? 0,
      lastDocumentUpload: parseString(json['last_document_upload']),
      lastDocumentUpdate: parseString(json['last_document_update']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
      v: json['__v'] ?? 0,
    );
  }
}

/* ================= USER ================= */

class User {
  final String id;
  final String role;
  final String parentId;
  final String name;
  final String mobile;
  final String email;
  final String accountStatus;
  final String accountStage;
  final String createdAt;
  final String updatedAt;
  final String lastLogin;
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
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseString(json['_id']),
      role: parseString(json['role']),
      parentId: parseString(json['parent_id']),
      name: parseString(json['name']),
      mobile: parseString(json['mobile']),
      email: parseString(json['email']),
      accountStatus: parseString(json['account_status']),
      accountStage: parseString(json['account_stage']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
      lastLogin: parseString(json['last_login']),
      v: json['__v'] ?? 0,
    );
  }
}

/* ================= SUMMARY ================= */

class RetailerSummary {
  final int total;
  final int active;
  final int inactive;
  final int deleted;

  RetailerSummary({
    required this.total,
    required this.active,
    required this.inactive,
    required this.deleted,
  });

  factory RetailerSummary.fromJson(Map<String, dynamic> json) {
    return RetailerSummary(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      inactive: json['inactive'] ?? 0,
      deleted: json['deleted'] ?? 0,
    );
  }
}

/* ================= PAGINATION ================= */

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }
}
