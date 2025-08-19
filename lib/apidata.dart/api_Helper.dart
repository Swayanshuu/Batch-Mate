import 'package:dio/dio.dart';

class ApiHelper {
  static const String baseUrl =
      "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches";

      static String? batchID;

  static Future<Map<String, dynamic>?> fetchBatchChild(
    String batchID,
    String childName,
  ) async {
    try {
      final url = "$baseUrl/$batchID/$childName.json";
      final response = await Dio().get(url);
      if (response.data != null && response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      }
    } catch (e) {
      print("Error fetching $childName: $e");
    }
    return null;
  }

  // Shortcuts
  static Future<Map<String, dynamic>?> getAssignments(String batchID) {
    return fetchBatchChild(batchID, "assignments");
  }

  static Future<Map<String, dynamic>?> getTimetables(String batchID) {
    return fetchBatchChild(batchID, "timetable");
  }

  static Future<Map<String, dynamic>?> getNotifications(String batchID) {
    return fetchBatchChild(batchID, "notifications");
  }
}
