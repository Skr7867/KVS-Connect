class EmiCompeletedModel {
  bool success;
  EmiCompeletedData data;

  EmiCompeletedModel({
    required this.success,
    required this.data,
  });

  factory EmiCompeletedModel.fromJson(Map<String, dynamic> json) {
    return EmiCompeletedModel(
      success: json['success'] ?? false,
      data: EmiCompeletedData.fromJson(json['data'] ?? {}),
    );
  }
}

/* ===================== DATA ===================== */

class EmiCompeletedData {
  List<EmiCustomer> customers;
  int total;
  int page;
  int limit;
  int totalPages;

  EmiCompeletedData({
    required this.customers,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory EmiCompeletedData.fromJson(Map<String, dynamic> json) {
    return EmiCompeletedData(
      customers: (json['customers'] as List? ?? [])
          .map((e) => EmiCustomer.fromJson(e))
          .toList(),
      total: int.tryParse(json['total']?.toString() ?? "") ?? 0,
      page: int.tryParse(json['page']?.toString() ?? "") ?? 0,
      limit: int.tryParse(json['limit']?.toString() ?? "") ?? 0,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? "") ?? 0,
    );
  }
}

/* ===================== CUSTOMER ===================== */

class EmiCustomer {
  String id;
  String name;
  String mobile;
  String email;

  EmiCustomer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
  });

  factory EmiCustomer.fromJson(Map<String, dynamic> json) {
    return EmiCustomer(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
    );
  }
}
