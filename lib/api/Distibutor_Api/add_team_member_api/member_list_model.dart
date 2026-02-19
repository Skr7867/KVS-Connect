// team_model.dart

// =================== HELPERS ===================

String parseString(dynamic v) => v?.toString() ?? "";

int parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

bool parseBool(dynamic v) {
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == "true";
  if (v is int) return v == 1;
  return false;
}

// =================== ROOT ===================

class TeamResponse {
  final bool success;
  final TeamData data;

  TeamResponse({
    required this.success,
    required this.data,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      success: parseBool(json["success"]),
      data: TeamData.fromJson(json["data"] ?? {}),
    );
  }
}

// =================== DATA ===================

class TeamData {
  final Team team;
  final List<Member> members;
  final Summary summary;
  final Pagination pagination;

  TeamData({
    required this.team,
    required this.members,
    required this.summary,
    required this.pagination,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      team: Team.fromJson(json["team"] ?? {}),
      members: (json["members"] as List? ?? [])
          .map((e) => Member.fromJson(e))
          .toList(),
      summary: Summary.fromJson(json["summary"] ?? {}),
      pagination: Pagination.fromJson(json["pagination"] ?? {}),
    );
  }
}

// =================== TEAM ===================

class Team {
  final String id;
  final String name;
  final String teamType;

  Team({
    required this.id,
    required this.name,
    required this.teamType,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: parseString(json["id"]),
      name: parseString(json["name"]),
      teamType: parseString(json["team_type"]),
    );
  }
}

// =================== MEMBER ===================

class Member {
  final String id;
  final User user;
  final String fullname;
  final String email;
  final String mobile;
  final String role;
  final String leaveStatus;
  final String status;
  final String kycStatus;
  final String commissionType;
  final int commissionValue;
  final Permissions permissions;
  final String createdAt;

  Member({
    required this.id,
    required this.user,
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.role,
    required this.leaveStatus,
    required this.status,
    required this.kycStatus,
    required this.commissionType,
    required this.commissionValue,
    required this.permissions,
    required this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: parseString(json["id"]),
      user: User.fromJson(json["user"] ?? {}),
      fullname: parseString(json["fullname"]),
      email: parseString(json["email"]),
      mobile: parseString(json["mobile"]),
      role: parseString(json["role"]),
      leaveStatus: parseString(json["leave_status"]),
      status: parseString(json["status"]),
      kycStatus: parseString(json["kyc_status"]),
      commissionType: parseString(json["commission_type"]),
      commissionValue: parseInt(json["commission_value"]),
      permissions: Permissions.fromJson(json["permissions"] ?? {}),
      createdAt: parseString(json["created_at"]),
    );
  }
}

// =================== USER ===================

class User {
  final String id;
  final String role;
  final String name;
  final String mobile;
  final String email;
  final String accountStatus;
  final String accountStage;

  User({
    required this.id,
    required this.role,
    required this.name,
    required this.mobile,
    required this.email,
    required this.accountStatus,
    required this.accountStage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseString(json["_id"]),
      role: parseString(json["role"]),
      name: parseString(json["name"]),
      mobile: parseString(json["mobile"]),
      email: parseString(json["email"]),
      accountStatus: parseString(json["account_status"]),
      accountStage: parseString(json["account_stage"]),
    );
  }
}

// =================== PERMISSIONS ===================

class Permissions {
  final bool canCreateRetailer;
  final bool canCreateCustomer;
  final bool canSellMobile;
  final bool canAssignKey;
  final bool canManageEmi;
  final bool canViewReports;

  Permissions({
    required this.canCreateRetailer,
    required this.canCreateCustomer,
    required this.canSellMobile,
    required this.canAssignKey,
    required this.canManageEmi,
    required this.canViewReports,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      canCreateRetailer: parseBool(json["can_create_retailer"]),
      canCreateCustomer: parseBool(json["can_create_customer"]),
      canSellMobile: parseBool(json["can_sell_mobile"]),
      canAssignKey: parseBool(json["can_assign_key"]),
      canManageEmi: parseBool(json["can_manage_emi"]),
      canViewReports: parseBool(json["can_view_reports"]),
    );
  }
}

// =================== SUMMARY ===================

class Summary {
  final int total;
  final int active;
  final int inactive;
  final int deleted;

  Summary({
    required this.total,
    required this.active,
    required this.inactive,
    required this.deleted,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      total: parseInt(json["total"]),
      active: parseInt(json["active"]),
      inactive: parseInt(json["inactive"]),
      deleted: parseInt(json["deleted"]),
    );
  }
}

// =================== PAGINATION ===================

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
      page: parseInt(json["page"]),
      limit: parseInt(json["limit"]),
      total: parseInt(json["total"]),
      pages: parseInt(json["pages"]),
    );
  }
}
