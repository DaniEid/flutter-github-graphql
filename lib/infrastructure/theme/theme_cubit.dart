import 'package:flutter_github_graphql/infrastructure/theme/app_theme.dart';
import 'package:flutter_github_graphql/infrastructure/theme/theme_state.dart';

import '../architecture/bloc/base_cubit.dart';

///Home Cubit that will have the repo and all the requests
class ThemeCubit extends BaseCubit {
  AppTheme appTheme = AppTheme.blueLight;

  bool get isLight => appTheme == AppTheme.blueLight;

  ThemeCubit()
      : super(ThemeChangedState(theme: appThemeData[AppTheme.blueLight]!));

  Future<void> changeTheme(AppTheme newTheme) async {
    appTheme = newTheme;
    emit(ThemeChangedState(theme: appThemeData[newTheme]!));
  }
}
