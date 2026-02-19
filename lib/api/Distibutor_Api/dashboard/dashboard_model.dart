// dashboard_model.dart

class DashboardModel {
  bool success;
  DashboardData data;

  DashboardModel({
    required this.success,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] ?? false,
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

// ================= DATA =================

class DashboardData {
  Distributor distributor;
  Team team;
  int totalRetailers;
  int activeRetailers;
  int totalCustomers;
  int totalKeysAllocated;
  int keysAvailable;
  int totalSales;
  List<RecentRetailer> recentRetailers;
  KeyAllocationStatus keyAllocationStatus;
  QuickActions quickActions;

  DashboardData({
    required this.distributor,
    required this.team,
    required this.totalRetailers,
    required this.activeRetailers,
    required this.totalCustomers,
    required this.totalKeysAllocated,
    required this.keysAvailable,
    required this.totalSales,
    required this.recentRetailers,
    required this.keyAllocationStatus,
    required this.quickActions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      distributor: Distributor.fromJson(json['distributor'] ?? {}),
      team: Team.fromJson(json['team'] ?? {}),
      totalRetailers: parseInt(json['total_retailers']),
      activeRetailers: parseInt(json['active_retailers']),
      totalCustomers: parseInt(json['total_customers']),
      totalKeysAllocated: parseInt(json['total_keys_allocated']),
      keysAvailable: parseInt(json['keys_available']),
      totalSales: parseInt(json['total_sales']),
      recentRetailers: (json['recent_retailers'] as List? ?? [])
          .map((e) => RecentRetailer.fromJson(e))
          .toList(),
      keyAllocationStatus:
      KeyAllocationStatus.fromJson(json['key_allocation_status'] ?? {}),
      quickActions: QuickActions.fromJson(json['quick_actions'] ?? {}),
    );
  }
}

// ================= DISTRIBUTOR =================

class Distributor {
  String id;
  String name;
  String mobile;
  String accountStatus;
  String lastLogin;

  Distributor({
    required this.id,
    required this.name,
    required this.mobile,
    required this.accountStatus,
    required this.lastLogin,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      accountStatus: json['account_status'] ?? "",
      lastLogin: json['last_login'] ?? "",
    );
  }
}

// ================= TEAM =================

class Team {
  int totalTeamMembers;
  int activeTeamMembers;

  Team({
    required this.totalTeamMembers,
    required this.activeTeamMembers,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      totalTeamMembers: parseInt(json['total_team_members']),
      activeTeamMembers: parseInt(json['active_team_members']),
    );
  }
}

// ================= RECENT RETAILER =================

class RecentRetailer {
  String id;
  String name;
  String mobile;
  String accountStatus;
  String createdAt;

  RecentRetailer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.accountStatus,
    required this.createdAt,
  });

  factory RecentRetailer.fromJson(Map<String, dynamic> json) {
    return RecentRetailer(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      accountStatus: json['account_status'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}

// ================= KEY ALLOCATION =================

class KeyAllocationStatus {
  int totalAllocated;
  int allocatedToRetailers;
  int unusedKeys;
  int inStock;
  int sold;
  int utilizationPercent;

  KeyAllocationStatus({
    required this.totalAllocated,
    required this.allocatedToRetailers,
    required this.unusedKeys,
    required this.inStock,
    required this.sold,
    required this.utilizationPercent,
  });

  factory KeyAllocationStatus.fromJson(Map<String, dynamic> json) {
    return KeyAllocationStatus(
      totalAllocated: parseInt(json['total_allocated']),
      allocatedToRetailers: parseInt(json['allocated_to_retailers']),
      unusedKeys: parseInt(json['unused_keys']),
      inStock: parseInt(json['in_stock']),
      sold: parseInt(json['sold']),
      utilizationPercent: parseInt(json['utilization_percent']),
    );
  }
}

// ================= QUICK ACTIONS =================

class QuickActions {
  bool buyPackage;
  bool allocateKey;

  QuickActions({
    required this.buyPackage,
    required this.allocateKey,
  });

  factory QuickActions.fromJson(Map<String, dynamic> json) {
    return QuickActions(
      buyPackage: json['buy_package'] ?? false,
      allocateKey: json['allocate_key'] ?? false,
    );
  }
}

// ================= HELPER =================

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
