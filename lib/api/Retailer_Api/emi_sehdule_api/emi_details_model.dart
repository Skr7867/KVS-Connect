class EmiDetailsModel {
  bool success;
  EmiData? data;

  EmiDetailsModel({
    required this.success,
    this.data,
  });

  factory EmiDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmiDetailsModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? EmiData.fromJson(json['data']) : null,
    );
  }
}

/// ---------------- EMI DATA ----------------
class EmiData {
  Emi? emi;
  List<Installment> installments;
  EmiSummary? summary;

  EmiData({
    this.emi,
    required this.installments,
    this.summary,
  });

  factory EmiData.fromJson(Map<String, dynamic> json) {
    return EmiData(
      emi: json['emi'] != null ? Emi.fromJson(json['emi']) : null,
      installments: (json['schedule'] as List? ?? [])
          .map((e) => Installment.fromJson(e))
          .toList(),
      summary: json['summary'] != null
          ? EmiSummary.fromJson(json['summary'])
          : null,

    );
  }
}

/// ---------------- EMI ----------------
class Emi {
  String id;
  double totalAmount;
  double monthlyAmount;
  int totalTenure;
  String status;

  Emi({
    required this.id,
    required this.totalAmount,
    required this.monthlyAmount,
    required this.totalTenure,
    required this.status,
  });

  factory Emi.fromJson(Map<String, dynamic> json) {
    return Emi(
      id: json['id'] ?? "",
      totalAmount:
      double.tryParse(json['total_amount']?.toString() ?? "") ?? 0,
      monthlyAmount:
      double.tryParse(json['monthly_amount']?.toString() ?? "") ?? 0,
      totalTenure:
      int.tryParse(json['total_tenure']?.toString() ?? "") ?? 0,
      status: json['status'] ?? "",
    );
  }
}

/// ---------------- PAYMENT SUMMARY ----------------
class PaymentSummary {
  double totalPaid;
  double totalPenalty;
  double remainingAmount;
  int paidTenure;
  int unpaidTenure;

  PaymentSummary({
    required this.totalPaid,
    required this.totalPenalty,
    required this.remainingAmount,
    required this.paidTenure,
    required this.unpaidTenure,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalPaid:
      double.tryParse(json['total_paid']?.toString() ?? "") ?? 0,
      totalPenalty:
      double.tryParse(json['total_penalty']?.toString() ?? "") ?? 0,
      remainingAmount:
      double.tryParse(json['remaining_amount']?.toString() ?? "") ?? 0,
      paidTenure:
      int.tryParse(json['paid_tenure']?.toString() ?? "") ?? 0,
      unpaidTenure:
      int.tryParse(json['unpaid_tenure']?.toString() ?? "") ?? 0,
    );
  }
}

/// ---------------- INSTALLMENT ----------------
class Installment {
  int installmentNumber;
  String dueDate;
  String status;
  String? paidDate;
  double amount;
  double penaltyAmount;

  Installment({
    required this.installmentNumber,
    required this.dueDate,
    required this.status,
    this.paidDate,
    required this.amount,
    required this.penaltyAmount,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      installmentNumber:
      int.tryParse(json['installment_number']?.toString() ?? "") ?? 0,
      dueDate: json['due_date'] ?? "",
      status: json['status'] ?? "",
      paidDate: json['paid_date'],
      amount:
      double.tryParse(json['amount']?.toString() ?? "") ?? 0,
      penaltyAmount:
      double.tryParse(json['penalty_amount']?.toString() ?? "") ?? 0,
    );
  }
}
/// ---------------- SUMMARY ----------------
class EmiSummary {
  int totalInstallments;
  int paidInstallments;
  int pendingInstallments;
  int overdueInstallments;
  String nextDueDate;
  double nextDueAmount;

  EmiSummary({
    required this.totalInstallments,
    required this.paidInstallments,
    required this.pendingInstallments,
    required this.overdueInstallments,
    required this.nextDueDate,
    required this.nextDueAmount,
  });

  factory EmiSummary.fromJson(Map<String, dynamic> json) {
    return EmiSummary(
      totalInstallments:
      int.tryParse(json['total_installments']?.toString() ?? "") ?? 0,
      paidInstallments:
      int.tryParse(json['paid_installments']?.toString() ?? "") ?? 0,
      pendingInstallments:
      int.tryParse(json['pending_installments']?.toString() ?? "") ?? 0,
      overdueInstallments:
      int.tryParse(json['overdue_installments']?.toString() ?? "") ?? 0,
      nextDueDate: json['next_due_date'] ?? "",
      nextDueAmount:
      double.tryParse(json['next_due_amount']?.toString() ?? "") ?? 0,
    );
  }
}
