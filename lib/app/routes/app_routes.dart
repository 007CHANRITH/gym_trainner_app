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
  static const LOGIN = _Paths.LOGIN;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const WELCOME = _Paths.WELCOME;
  static const GET_STARTED = _Paths.GET_STARTED;
  static const GENDER_SELECTION = _Paths.GENDER_SELECTION;
  static const AGE_INPUT = _Paths.AGE_INPUT;
  static const WEIGHT_INPUT = _Paths.WEIGHT_INPUT;
  static const HEIGHT_INPUT = _Paths.HEIGHT_INPUT;
  static const FITNESS_GOAL = _Paths.FITNESS_GOAL;
  static const ACTIVITY_LEVEL = _Paths.ACTIVITY_LEVEL;
  static const FITNESS_LEVEL = _Paths.FITNESS_LEVEL;
  static const NOTIFICATION_PERMISSION = _Paths.NOTIFICATION_PERMISSION;
  static const PROFILE_SUMMARY = _Paths.PROFILE_SUMMARY;
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
  static const LOGIN = '/login';
  static const SIGN_UP = '/sign-up';
  static const WELCOME = '/welcome';
  static const GET_STARTED = '/get-started';
  static const GENDER_SELECTION = '/gender-selection';
  static const AGE_INPUT = '/age-input';
  static const WEIGHT_INPUT = '/weight-input';
  static const HEIGHT_INPUT = '/height-input';
  static const FITNESS_GOAL = '/fitness-goal';
  static const ACTIVITY_LEVEL = '/activity-level';
  static const FITNESS_LEVEL = '/fitness-level';
  static const NOTIFICATION_PERMISSION = '/notification-permission';
  static const PROFILE_SUMMARY = '/profile-summary';
}
