// Mock Cubit
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_state.dart';
import 'package:flutter_github_graphql/presentation/home_screen/cubit/home_screen_cubit.dart';

class MockHomeCubit extends MockCubit<BaseState> implements HomeScreenCubit {}
