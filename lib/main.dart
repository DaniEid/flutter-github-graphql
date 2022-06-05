import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_graphql/infrastructure/di/app_bloc_providers.dart';
import 'package:flutter_github_graphql/infrastructure/theme/bloc.dart';

import 'infrastructure/architecture/bloc/base_state.dart';
import 'infrastructure/di/app_initializer.dart';
import 'infrastructure/routing/app_router.gr.dart';

void main() async {
  await AppInitializer.setupPrerequisites();

  runZonedGuarded(
    () async {
      runApp(MyApp());
    },
    (error, stack) {
      log("App Error with: $error");

      log("App Error stack: $stack");
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _rootRouter = AppRouter(
      // authGuard: AuthGuard(),
      );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: appProviders,
      child: BlocBuilder<ThemeCubit, BaseState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerDelegate: _rootRouter.delegate(),
            routeInformationProvider: _rootRouter.routeInfoProvider(),
            routeInformationParser: _rootRouter.defaultRouteParser(),
            title: 'Flutter Demo',
            theme: state is ThemeChangedState
                ? state.theme
                : appThemeData[AppTheme.blueLight],
            builder: (_, router) {
              return router!;
            },
          );
        },
      ),
    );
  }
}
