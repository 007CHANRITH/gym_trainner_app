import 'package:get/get.dart';
import 'package:gym_trainer/app/modules/favourite/controllers/favourite_controller.dart';

class FavouriteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouriteController>(
      () => FavouriteController(),
    );
  }
}