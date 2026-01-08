import 'package:lost_n_found/core/config/environment_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Platform-aware configuration
  // Uses EnvironmentConfig to get the appropriate URL based on platform
  static String baseUrl = EnvironmentConfig.getBaseUrl();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Batch Endpoints ============
  static const String batches = '/batches';
  static String batchById(String id) => '/batches/$id';

  // ============ Category Endpoints ============
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // ============ Student Endpoints ============
  static const String students = '/students';
  static const String studentLogin = '/students/login';
  // static const String studentRegister = '/students/register';
  static String studentById(String id) => '/students/$id';
  static String studentPhoto(String id) => '/students/$id/photo';

  // ============ Item Endpoints ============
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';

  // ============ Comment Endpoints ============
  static const String comments = '/comments';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/item/$itemId';
  static String commentLike(String id) => '/comments/$id/like';
}
