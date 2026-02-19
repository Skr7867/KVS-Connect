// teammembermodel.dart

class GetRetailerTeamMembers {
  final bool success;
  final RetailerTeamData data;

  GetRetailerTeamMembers({
    required this.success,
    required this.data,
  });

  factory GetRetailerTeamMembers.fromJson(Map<String, dynamic> json) {
    return GetRetailerTeamMembers(
      success: json['success'] ?? false,
      data: RetailerTeamData.fromJson(json['data'] ?? {}),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  MAIN DATA                                 */
/* -------------------------------------------------------------------------- */

class RetailerTeamData {
  final Team team;
  final List<TeamMemberModel> members;
  final TeamSummary summary;
  final Pagination pagination;

  RetailerTeamData({
    required this.team,
    required this.members,
    required this.summary,
    required this.pagination,
  });

  factory RetailerTeamData.fromJson(Map<String, dynamic> json) {
    return RetailerTeamData(
      team: Team.fromJson(json['team'] ?? {}),
      members: (json['members'] as List? ?? [])
          .map((e) => TeamMemberModel.fromJson(e))
          .toList(),
      summary: TeamSummary.fromJson(json['summary'] ?? {}),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    TEAM                                    */
/* -------------------------------------------------------------------------- */

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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      teamType: json['team_type'] ?? '',
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                TEAM MEMBER                                 */
/* -------------------------------------------------------------------------- */

class TeamMemberModel {
  final String id;
  final UserModel user;
  final String fullname;
  final String email;
  final String mobile;
  final String role;
  final String shopBranchName;
  final String leaveStatus;
  final String status;
  final String kycStatus;
  final Permissions permissions;
  final DateTime createdAt;

  TeamMemberModel({
    required this.id,
    required this.user,
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.role,
    required this.shopBranchName,
    required this.leaveStatus,
    required this.status,
    required this.kycStatus,
    required this.permissions,
    required this.createdAt,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? '',
      shopBranchName: json['shop_branch_name'] ?? '',
      leaveStatus: json['leave_status'] ?? '',
      status: json['status'] ?? '',
      kycStatus: json['kyc_status'] ?? '',
      permissions: Permissions.fromJson(json['permissions'] ?? {}),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    USER                                    */
/* -------------------------------------------------------------------------- */

class UserModel {
  final String id;
  final String role;
  final String name;
  final String mobile;
  final String email;
  final String accountStatus;
  final String accountStage;

  UserModel({
    required this.id,
    required this.role,
    required this.name,
    required this.mobile,
    required this.email,
    required this.accountStatus,
    required this.accountStage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      accountStatus: json['account_status'] ?? '',
      accountStage: json['account_stage'] ?? '',
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 PERMISSIONS                                 */
/* -------------------------------------------------------------------------- */

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
      canCreateRetailer: json['can_create_retailer'] ?? false,
      canCreateCustomer: json['can_create_customer'] ?? false,
      canSellMobile: json['can_sell_mobile'] ?? false,
      canAssignKey: json['can_assign_key'] ?? false,
      canManageEmi: json['can_manage_emi'] ?? false,
      canViewReports: json['can_view_reports'] ?? false,
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   SUMMARY                                  */
/* -------------------------------------------------------------------------- */

class TeamSummary {
  final int total;
  final int active;
  final int inactive;
  final int deleted;

  TeamSummary({
    required this.total,
    required this.active,
    required this.inactive,
    required this.deleted,
  });

  factory TeamSummary.fromJson(Map<String, dynamic> json) {
    return TeamSummary(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      inactive: json['inactive'] ?? 0,
      deleted: json['deleted'] ?? 0,
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 PAGINATION                                 */
/* -------------------------------------------------------------------------- */

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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }
}
