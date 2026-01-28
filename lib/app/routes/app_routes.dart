part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const FAVORITE = _Paths.FAVORITE;
  static const WALLET = _Paths.WALLET;
  static const PROFILE = _Paths.PROFILE;
  static const FAVOURITE = _Paths.FAVOURITE;
  static const TRAINER_DETAILS = _Paths.TRAINER_DETAILS;
  static const MESSAGE_SCREEN = _Paths.MESSAGE_SCREEN;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const FAVORITE = '/favorite';
  static const WALLET = '/wallet';
  static const PROFILE = '/profile';
  static const FAVOURITE = '/favourite';
  static const TRAINER_DETAILS = '/trainer-details';
  static const MESSAGE_SCREEN = '/message-screen';
}
