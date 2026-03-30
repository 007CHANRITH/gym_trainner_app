import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/services/bookings_service.dart';
import 'app/services/favourites_service.dart';
import 'app/services/user_profile_service.dart';
import 'app/services/user_role_service.dart';
import 'app/services/user_support_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling and retry for iOS
  bool firebaseInitialized = false;
  int retryCount = 0;
  while (!firebaseInitialized && retryCount < 3) {
    try {
      await Firebase.initializeApp();
      firebaseInitialized = true;
      debugPrint('✅ Firebase initialized successfully');
    } catch (e) {
      retryCount++;
      debugPrint('⚠️ Firebase init attempt $retryCount failed: $e');
      if (retryCount < 3) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  if (!firebaseInitialized) {
    debugPrint('❌ Firebase initialization failed after 3 attempts');
  }

  try {
    await Supabase.initialize(
      url: 'https://wrnimhuovvyhysiufffd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndybmltaHVvdnZ5aHlzaXVmZmZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzNjQ5MDAsImV4cCI6MjA4ODk0MDkwMH0.e475CUbWI2J6avGJWQsm2oG6QhRLXCRL5eHXbbQD_DU',
    );
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Supabase initialization error: $e');
  }

  // Register global services - create immediately so they're available
  Get.put<UserSupportService>(UserSupportService());
  Get.put<UserRoleService>(UserRoleService());

  // These can initialize asynchronously in background
  Get.putAsync<BookingsService>(() async => BookingsService());
  Get.putAsync<FavouritesService>(() async => FavouritesService());
  Get.putAsync<UserProfileService>(() async => UserProfileService().init());

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1E1C26),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    GetMaterialApp(
      title: 'Gym Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121217),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF896CFE),
          secondary: Color(0xFFE2F163),
          surface: Color(0xFF1E1C26),
        ),
      ),
      defaultTransition: Transition.cupertino,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
