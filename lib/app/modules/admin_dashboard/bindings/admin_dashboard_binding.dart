import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';
import '../../../services/admin_api_service.dart';
import '../../../services/admin_permission_service.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Register permission service first (needed by controller)
    Get.putAsync<AdminPermissionService>(() async {
      final service = AdminPermissionService();
      await service.init();
      return service;
    }, tag: null);

    // Register API service (needs to verify admin role)
    Get.putAsync<AdminApiService>(() async {
      final api = AdminApiService();
      await api.init();
      return api;
    }, tag: null);

    // Register dashboard controller
    Get.put<AdminDashboardController>(
      AdminDashboardController(),
      permanent: false,
    );
  }
}
