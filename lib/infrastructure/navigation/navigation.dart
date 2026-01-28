import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import 'package:gym_trainer/app/modules/favourite/views/favourite_view.dart';
import 'package:gym_trainer/app/modules/favourite/bindings/favourite_binding.dart';
// ...existing code...
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.FAVOURITE,
      page: () => const FavouriteView(),
      binding: FavouriteBinding(), // Ensure FavouriteBinding is correctly imported and defined
    ),
    
  ];
}
