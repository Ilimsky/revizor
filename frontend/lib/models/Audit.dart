class Audit {
  final int id;
  final int auditNumber;
  final int departmentId;
  final String? approvalDate;
  final double? approvedAmount;
  final DateTime dateReceived;
  final String amountIssued;
  final String comments;

  Audit({
    required this.id,
    required this.auditNumber,
    required this.departmentId,
    this.approvalDate,
    this.approvedAmount,
    required this.dateReceived,
    required this.amountIssued,
    required this.comments,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return Audit(
      id: json['id'],
      auditNumber: json['auditNumber'],
      departmentId: json['departmentId'],
      approvalDate: json['approvalDate'],
      approvedAmount: json['approvedAmount']?.toDouble(),
      dateReceived: DateTime.parse(json['dateReceived']),
      amountIssued: json['amountIssued'],
      comments: json['comments'],
    );
  }
}