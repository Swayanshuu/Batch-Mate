import 'package:dio/dio.dart';

class ApiHelper {
  static const String baseUrl =
      "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches";

  static String? batchID;

  static Future<dynamic> fetchBatchChild(
    String batchID,
    String childName,
  ) async {
    try {
      final url = "$baseUrl/$batchID/$childName.json";
      final response = await Dio().get(url);
      return response.data;
    } catch (e) {
      print("Error fetching $childName: $e");
    }
    return null;
  }

  // Shortcuts
static Future<String?> batchName(String batchID) async {
  final data = await fetchBatchChild(batchID, "name");
  return data is String ? data : null;
}

static Future<String?> batchCreatedBy(String batchID) async {
  final data = await fetchBatchChild(batchID, "createdBy");
  return data is String ? data : null;
}

// Maps
static Future<Map<String, dynamic>?> getAssignments(String batchID) async {
  final data = await fetchBatchChild(batchID, "assignments");
  return data is Map ? Map<String, dynamic>.from(data) : null;
}

static Future<Map<String, dynamic>?> getTimetables(String batchID) async {
  final data = await fetchBatchChild(batchID, "timetable");
  return data is Map ? Map<String, dynamic>.from(data) : null;
}

static Future<Map<String, dynamic>?> getNotices(String batchID) async {
  final data = await fetchBatchChild(batchID, "notifications");
  return data is Map ? Map<String, dynamic>.from(data) : null;
}

}
