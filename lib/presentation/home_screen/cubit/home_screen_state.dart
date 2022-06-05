import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_state.dart';

class LoadingMoreState<T> extends BaseState {
  final T response;

  LoadingMoreState(this.response);

  @override
  List<T> get props => [response];
}
