class Audit {
  final int id;
  final int auditNumber;
  final int departmentId;
  final int employeeId;
  final int revizorId;
  final DateTime dateReceived;
  final String ticket;
  final String purpose;
  final String comments;


  Audit({
    required this.id,
    required this.auditNumber,
    required this.departmentId,
    required this.employeeId,
    required this.revizorId,
    required this.dateReceived,
    required this.ticket,
    required this.purpose,
    required this.comments,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return Audit(
      id: json['id'] as int? ?? 0,
      auditNumber: json['auditNumber'] as int? ?? 0,
      departmentId: json['departmentId'] as int? ?? 0,
      employeeId: json['employeeId'] as int? ?? 0,
      revizorId: json['revizorId'] as int? ?? 0,
      dateReceived: DateTime.parse(json['dateReceived'] as String? ?? '1970-01-01'),
      ticket: json['ticket'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      comments: json['comments'] as String? ?? '',
    );
  }
}