import 'package:dio/dio.dart';

import '../models/Department.dart';
import '../models/Employee.dart';
import '../models/Audit.dart';
import '../models/Revizor.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'https://revizor-c443.onrender.com/api'));

  Future<List<Department>> fetchDepartments() async {
    try {
      final response = await _dio.get('/departments');
      return (response.data as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Department> createDepartment(String name) async {
    try {
      final response = await _dio.post('/departments', data: {'name': name});
      return Department.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Department> updateDepartment(int id, String newName) async {
    try {
      final response =
          await _dio.put('/departments/$id', data: {'name': newName});
      return Department.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await _dio.delete('/departments/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Audit>> fetchAllAudits() async {
    try {
      final response = await _dio.get(
        '/audits',
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((json) => Audit.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load audits');
      }
    } catch (e) {
      if (e is DioException) {
        // Handle Dio-specific errors
        print('Dio error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<List<Audit>> fetchAuditsByDepartment(int departmentId) async {
    try {
      final response = await _dio.get('/audits/department/$departmentId');
      return (response.data as List)
          .map((json) => Audit.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Audit> createAudit({
    required int departmentId,
    // required int jobId,
    required int employeeId,
    required int revizorId,
    required String dateReceived,
    required String ticket,
    // required String amountIssued,
    // required String dateApproved,
    required String purpose,
    // required String recognizedAmount,
    required String comments,
  }) async {
    try {
      final response = await _dio.post(
        '/audits',
        data: {
          'departmentId': departmentId,
          // 'jobId': jobId,
          'employeeId': employeeId,
          'revizorId': revizorId,
          'dateReceived': dateReceived,
          'ticket': ticket,
          // 'amountIssued': amountIssued,
          // 'dateApproved': dateApproved,
          'purpose': purpose,
          // 'recognizedAmount': recognizedAmount,
          'comments': comments,
        },
      );
      return Audit.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Audit> updateAudit(
      int auditId, {
        required int auditNumber,
        required int departmentId,
        required String ticket,
        required String purpose,
        required int employeeId,
        required int revizorId,
        required String comments,
      }) async {
    try {
      final response = await _dio.put('/audits/$auditId', data: {
        'auditNumber': auditNumber,
        'departmentId': departmentId,
        'ticket': ticket,
        'purpose': purpose,
        'employeeId': employeeId,
        'revizorId': revizorId,
        'comments': comments,
      });
      return Audit.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAudit(int auditId) async {
    try {
      await _dio.delete('/audits/$auditId');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await _dio.get('/employees');
      return (response.data as List)
          .map((json) => Employee.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Employee> createEmployee(String name) async {
    try {
      final response = await _dio.post('/employees', data: {'name': name});
      return Employee.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Employee> updateEmployee(int id, String newName) async {
    try {
      final response =
          await _dio.put('/employees/$id', data: {'name': newName});
      return Employee.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _dio.delete('/employees/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Revizor>> fetchRevizors() async {
    try {
      final response = await _dio.get('/revizors');
      return (response.data as List)
          .map((json) => Revizor.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Revizor> createRevizor(String name) async {
    try {
      final response = await _dio.post('/revizors', data: {'name': name});
      return Revizor.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Revizor> updateRevizor(int id, String newName) async {
    try {
      final response =
      await _dio.put('/revizors/$id', data: {'name': newName});
      return Revizor.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRevizor(int id) async {
    try {
      await _dio.delete('/revizors/$id');
    } catch (e) {
      rethrow;
    }
  }
}
