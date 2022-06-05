import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_graphql/data/data_source/remote/github_services.dart';
import 'package:flutter_github_graphql/data/data_source/remote/graphql_service.dart';
import 'package:flutter_github_graphql/data/repository_impl/home_repository_impl.dart';
import 'package:flutter_github_graphql/domain/usecase/home_screen_usecase.dart';
import 'package:flutter_github_graphql/infrastructure/constants/widget_keys.dart';
import 'package:flutter_github_graphql/infrastructure/theme/bloc.dart';
import 'package:flutter_github_graphql/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:flutter_github_graphql/presentation/home_screen/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'HomeScreen',
    () {
      testWidgets(
        "Test light screen",
        (WidgetTester tester) async {
          final themeSwitcherButton = find.byKey(themeModeSwitcherKey);
          HomeScreenUseCase homeScreenUseCase = HomeScreenUseCase(
            HomeScreenRepositoryImpl(
              GithubServices(
                GraphQLService(),
              ),
            ),
          );

          HomeScreenCubit homeCubit = HomeScreenCubit(homeScreenUseCase);
          ThemeCubit themeCubit = ThemeCubit();

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                    lazy: false, create: (context) => themeCubit),
                BlocProvider<HomeScreenCubit>(
                    lazy: false, create: (context) => homeCubit),
              ],
              child: const MaterialApp(
                home: HomeScreen(),
              ),
            ),
          );

          await tester.pumpAndSettle();
          await tester.tap(themeSwitcherButton);

          expect(themeCubit.isLight, false);
        },
      );

      testWidgets(
        "Test sort button",
        (WidgetTester tester) async {
          HomeScreenUseCase homeScreenUseCase = HomeScreenUseCase(
            HomeScreenRepositoryImpl(
              GithubServices(
                GraphQLService(),
              ),
            ),
          );

          HomeScreenCubit homeCubit = HomeScreenCubit(homeScreenUseCase);
          ThemeCubit themeCubit = ThemeCubit();

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                    lazy: false, create: (context) => themeCubit),
                BlocProvider<HomeScreenCubit>(
                    lazy: false, create: (context) => homeCubit),
              ],
              child: const MaterialApp(
                home: HomeScreen(),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byKey(sortButtonKey), findsOneWidget);
        },
      );

      testWidgets(
        "Test filter button",
        (WidgetTester tester) async {
          HomeScreenUseCase homeScreenUseCase = HomeScreenUseCase(
            HomeScreenRepositoryImpl(
              GithubServices(
                GraphQLService(),
              ),
            ),
          );

          HomeScreenCubit homeCubit = HomeScreenCubit(homeScreenUseCase);
          ThemeCubit themeCubit = ThemeCubit();

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                    lazy: false, create: (context) => themeCubit),
                BlocProvider<HomeScreenCubit>(
                    lazy: false, create: (context) => homeCubit),
              ],
              child: const MaterialApp(
                home: HomeScreen(),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byKey(filterButtonKey), findsOneWidget);
        },
      );

      testWidgets(
        "Test filter bottom sheet",
        (WidgetTester tester) async {
          HomeScreenUseCase homeScreenUseCase = HomeScreenUseCase(
            HomeScreenRepositoryImpl(
              GithubServices(
                GraphQLService(),
              ),
            ),
          );

          HomeScreenCubit homeCubit = HomeScreenCubit(homeScreenUseCase);
          ThemeCubit themeCubit = ThemeCubit();

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                    lazy: false, create: (context) => themeCubit),
                BlocProvider<HomeScreenCubit>(
                    lazy: false, create: (context) => homeCubit),
              ],
              child: const MaterialApp(
                home: HomeScreen(),
              ),
            ),
          );
          final filterButton = find.byKey(filterButtonKey);

          await tester.tap(filterButton);
          await tester.pumpAndSettle();

          expect(find.byKey(filterSheetKey), findsOneWidget);
        },
      );

      ///EOF
    },
  );
}
