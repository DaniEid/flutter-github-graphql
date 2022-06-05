// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_github_graphql/data/data_source/remote/github_services.dart';
import 'package:flutter_github_graphql/data/data_source/remote/graphql_service.dart';
import 'package:flutter_github_graphql/data/enum/issue_status.dart';
import 'package:flutter_github_graphql/data/model/filter_issues.dart';
import 'package:flutter_github_graphql/data/repository_impl/home_repository_impl.dart';
import 'package:flutter_github_graphql/domain/usecase/home_screen_usecase.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_state.dart';
import 'package:flutter_github_graphql/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_home_cubit.dart';

void main() {
  mainCubit();
}

void mainCubit() {
  group('whenListen', () {
    test("Let's mock the HomeScreen's stream!", () {
      // Create Mock CounterCubit Instance
      final cubit = MockHomeCubit();

      // Stub the listen with a fake Stream
      whenListen(
          cubit,
          Stream.fromIterable([
            LoadingState(),
            SuccessState(const []),
            LoadingState(),
          ]));

      // states
      expectLater(
          cubit.stream,
          emitsInOrder(
            <BaseState>[
              LoadingState(),
              SuccessState(const []),
              LoadingState(),
            ],
          ));
    });
  });

  group('HomeScreenCubit', () {
    HomeScreenUseCase homeScreenUseCase = HomeScreenUseCase(
      HomeScreenRepositoryImpl(
        GithubServices(
          GraphQLService(),
        ),
      ),
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Emits [] when nothing is called',
      build: () => HomeScreenCubit(homeScreenUseCase),
      expect: () => const [],
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify that data is cleared',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) => cubit.clearData(),
      verify: (cubit) => cubit.issues.isEmpty,
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify that paging info is cleared',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) => cubit.clearData(),
      verify: (cubit) => cubit.pageInfo == null,
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify clear filter data',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) => cubit.clearFilter(),
      verify: (cubit) {
        cubit.filterIssues == null;
        cubit.createdByController.text.isEmpty;
        cubit.assigneeController.text.isEmpty;
      },
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify get data that is not empty',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) => cubit.getDate(),
      verify: (cubit) => cubit.issues.isNotEmpty && cubit.pageInfo != null,
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify paging is working',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) async {
        await cubit.getDate();

        if (cubit.pageInfo != null) {
          final lastIssue = cubit.pageInfo!.endCursor;

          await cubit.getDate(lastIssue: lastIssue);
        }
      },
      verify: (cubit) => cubit.issues.isNotEmpty && cubit.issues.length == 20,
    );

    blocTest<HomeScreenCubit, BaseState>(
      'Verify filters is working with the API with some random name',
      build: () => HomeScreenCubit(homeScreenUseCase),
      act: (cubit) async {
        await cubit.getDate();

        const _chars =
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        Random _rnd = Random();
        final unRealName = String.fromCharCodes(Iterable.generate(
            12, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

        cubit.filterIssues =
            FilterIssues(states: [IssueStatus.closed], createdBy: unRealName);
      },
      verify: (cubit) => cubit.issues.isEmpty,
    );
  });
}
