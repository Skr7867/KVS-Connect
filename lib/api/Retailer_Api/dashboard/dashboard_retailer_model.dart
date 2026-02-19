/* ================= Helper Functions ================= */

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

String parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

/* ================= Main Model ================= */

class RetailerDashboardModel {
  final bool success;
  final RetailerDashboardData? data;

  RetailerDashboardModel({
    required this.success,
    this.data,
  });

  factory RetailerDashboardModel.fromJson(Map<String, dynamic> json) {
    return RetailerDashboardModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? RetailerDashboardData.fromJson(json['data'])
          : null,
    );
  }
}

/* ================= Data Model ================= */

class RetailerDashboardData {
  final String retailerName;
  final String shopName;
  final String ownerName;

  final int totalCustomers;
  final int activeCustomers;
  final int pendingKyc;
  final int totalEmiAmount;
  final int monthlyCollections;
  final int dailySalesTotal;
  final int keysActivatedToday;
  final int availableKeysForActivation;
  final int pendingCollections;
  final int overdueCount;

  final int totalTeamMembers;
  final int totalPhonesSold;
  final int completedEmiCount;
  final int bouncedEmiCount;



  final List<RecentCustomer> recentCustomers;
  final List<RecentPayment> recentPayments;
  final List<UpcomingDuePayment> upcomingDuePayments;

  RetailerDashboardData({
    required this.retailerName,
    required this.shopName,
    required this.ownerName,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.pendingKyc,
    required this.totalEmiAmount,
    required this.monthlyCollections,
    required this.dailySalesTotal,
    required this.keysActivatedToday,
    required this.availableKeysForActivation,
    required this.pendingCollections,
    required this.overdueCount,

    required this.totalTeamMembers,
    required this.totalPhonesSold,
    required this.completedEmiCount,
    required this.bouncedEmiCount,

    required this.recentCustomers,
    required this.recentPayments,
    required this.upcomingDuePayments,
  });

  factory RetailerDashboardData.fromJson(Map<String, dynamic> json) {
    return RetailerDashboardData(
      retailerName: parseString(json['retailer_name']),
      shopName: parseString(json['shop_name']),
      ownerName: parseString(json['owner_name']),
      totalCustomers: parseInt(json['total_customers']),
      activeCustomers: parseInt(json['active_customers']),
      pendingKyc: parseInt(json['pending_kyc']),
      totalEmiAmount: parseInt(json['total_emi_amount']),
      monthlyCollections: parseInt(json['monthly_collections']),
      dailySalesTotal: parseInt(json['daily_sales_total']),
      keysActivatedToday: parseInt(json['keys_activated_today']),
      availableKeysForActivation:
      parseInt(json['available_keys_for_activation']),
      pendingCollections: parseInt(json['pending_collections']),
      overdueCount: parseInt(json['overdue_count']),

      totalTeamMembers: parseInt(json['total_team_members']),
      totalPhonesSold: parseInt(json['total_phones_sold']),
      completedEmiCount: parseInt(json['completed_emi_count']),
      bouncedEmiCount: parseInt(json['bounced_emi_count']),

      recentCustomers: (json['recent_customers'] as List? ?? [])
          .map((e) => RecentCustomer.fromJson(e))
          .toList(),
      recentPayments: (json['recent_payments'] as List? ?? [])
          .map((e) => RecentPayment.fromJson(e))
          .toList(),
      upcomingDuePayments: (json['upcoming_due_payments'] as List? ?? [])
          .map((e) => UpcomingDuePayment.fromJson(e))
          .toList(),
    );
  }
}

/* ================= Recent Customers ================= */

class RecentCustomer {
  final String id;
  final String fullName;
  final String mobile;
  final String kycStatus;
  final String createdAt;

  RecentCustomer({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.kycStatus,
    required this.createdAt,
  });

  factory RecentCustomer.fromJson(Map<String, dynamic> json) {
    return RecentCustomer(
      id: parseString(json['id']),
      fullName: parseString(json['full_name']),
      mobile: parseString(json['mobile']),
      kycStatus: parseString(json['kyc_status']),
      createdAt: parseString(json['created_at']),
    );
  }
}

/* ================= Recent Payments ================= */

class RecentPayment {
  final String id;
  final String customerName;
  final int amount;
  final String paidOn;
  final String paymentMode;
  final String receiptNo;

  RecentPayment({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.paidOn,
    required this.paymentMode,
    required this.receiptNo,
  });

  factory RecentPayment.fromJson(Map<String, dynamic> json) {
    return RecentPayment(
      id: parseString(json['id']),
      customerName: parseString(json['customer_name']),
      amount: parseInt(json['amount']),
      paidOn: parseString(json['paid_on']),
      paymentMode: parseString(json['payment_mode']),
      receiptNo: parseString(json['receipt_no']),
    );
  }
}

/* ================= Upcoming Due Payments ================= */

class UpcomingDuePayment {
  final String customerId;
  final String emiId;
  final String dueDate;
  final int amount;
  final int daysUntilDue;

  UpcomingDuePayment({
    required this.customerId,
    required this.emiId,
    required this.dueDate,
    required this.amount,
    required this.daysUntilDue,
  });

  factory UpcomingDuePayment.fromJson(Map<String, dynamic> json) {
    return UpcomingDuePayment(
      customerId: parseString(json['customer_id']),
      emiId: parseString(json['emi_id']),
      dueDate: parseString(json['due_date']),
      amount: parseInt(json['amount']),
      daysUntilDue: parseInt(json['days_until_due']),
    );
  }
}
