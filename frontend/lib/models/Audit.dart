class Audit {
  final int id;
  final int auditNumber;
  final int departmentId;
  final int employeeId;
  // final String? approvalDate;
  // final double? approvedAmount;
  final DateTime dateReceived;
  final String purpose;
  final String comments;

  Audit({
    required this.id,
    required this.auditNumber,
    required this.departmentId,
    required this.employeeId,
    // this.approvalDate,
    // this.approvedAmount,
    required this.dateReceived,
    required this.purpose,
    required this.comments,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return Audit(
      id: json['id'],
      auditNumber: json['auditNumber'],
      departmentId: json['departmentId'],
      employeeId: json['employeeId'],
      // approvalDate: json['approvalDate'],
      // approvedAmount: json['approvedAmount']?.toDouble(),
      dateReceived: DateTime.parse(json['dateReceived']),
      purpose: json['purpose'],
      comments: json['comments'],
    );
  }
}