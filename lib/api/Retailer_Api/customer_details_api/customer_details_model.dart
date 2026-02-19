// customer_details.dart

class CustomerDetailsResponse {
  final bool success;
  final CustomerDetailsData data;

  CustomerDetailsResponse({
    required this.success,
    required this.data,
  });

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsResponse(
      success: json['success'],
      data: CustomerDetailsData.fromJson(json['data']),
    );
  }
}

/* ===================== DATA ===================== */

class CustomerDetailsData {
  final Customer customer;
  final List<CustomerDocument> documents;
  final List<CustomerReference> references;
  final int documentCount;
  final String lastDocumentUpload;
  final String lastDocumentUpdate;

  CustomerDetailsData({
    required this.customer,
    required this.documents,
    required this.references,
    required this.documentCount,
    required this.lastDocumentUpload,
    required this.lastDocumentUpdate,
  });

  factory CustomerDetailsData.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsData(
      customer: Customer.fromJson(json['customer'] ?? {}),
      documents: (json['documents'] as List? ?? [])
          .map((e) => CustomerDocument.fromJson(e))
          .toList(),
      references: (json['references'] as List? ?? [])
          .map((e) => CustomerReference.fromJson(e))
          .toList(),
      documentCount: json['document_count'] ?? 0,
      lastDocumentUpload: json['last_document_upload'] ?? '',
      lastDocumentUpdate: json['last_document_update'] ?? '',
    );
  }
}

/* ===================== CUSTOMER ===================== */

class Customer {
  final String id;
  final User user;
  final User retailer;
  final String fullName;
  final String mobile;
  final String email;
  final String bankName;
  final String accountNo;
  final String ifscCode;
  final String accountHolderName;
  final int mandateAmount;
  final String mandateFrequency;
  final int installmentDuration;
  final String mandateStartDate;
  final String mandateEndDate;
  final String notes;
  final String kycStatus;
  final String createdAt;
  final String updatedAt;

  Customer({
    required this.id,
    required this.user,
    required this.retailer,
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.accountHolderName,
    required this.mandateAmount,
    required this.mandateFrequency,
    required this.installmentDuration,
    required this.mandateStartDate,
    required this.mandateEndDate,
    required this.notes,
    required this.kycStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user_id'] ?? {}),
      retailer: User.fromJson(json['retailer_id'] ?? {}),
      fullName: json['full_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      mandateAmount: json['mandate_amount'] ?? 0,
      mandateFrequency: json['mandate_frequency'] ?? '',
      installmentDuration: json['installment_duration'] ?? 0,
      mandateStartDate: json['mandate_start_date'] ?? '',
      mandateEndDate: json['mandate_end_date'] ?? '',
      notes: json['notes'] ?? '',
      kycStatus: json['kyc_status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
/* ===================== USER (Customer & Retailer) ===================== */

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
  final String? lastLogin;

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
    this.lastLogin,
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
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      lastLogin: json['last_login'], // nullable is OK
    );
  }

}

/* ===================== DOCUMENT ===================== */

class CustomerDocument {
  final String id;
  final String userId;
  final String entityType;
  final String entityId;
  final String docType;
  final String filePath;
  final int fileSize;
  final String mimeType;
  final String uploadedAt;
  final String createdAt;
  final String updatedAt;

  CustomerDocument({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.docType,
    required this.filePath,
    required this.fileSize,
    required this.mimeType,
    required this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerDocument.fromJson(Map<String, dynamic> json) {
    return CustomerDocument(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id'] ?? '',
      docType: json['doc_type'] ?? '',
      filePath: json['file_path'] ?? '',
      fileSize: json['file_size'] ?? 0,
      mimeType: json['mime_type'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

}

/* ===================== REFERENCES ===================== */

class CustomerReference {
  final String id;
  final String customerId;
  final String referenceName;
  final String referenceMobile;
  final String createdAt;
  final String updatedAt;

  CustomerReference({
    required this.id,
    required this.customerId,
    required this.referenceName,
    required this.referenceMobile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerReference.fromJson(Map<String, dynamic> json) {
    return CustomerReference(
      id: json['_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      referenceName: json['reference_name'] ?? '',
      referenceMobile: json['reference_mobile'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

}
