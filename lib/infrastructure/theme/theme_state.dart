import 'package:flutter/material.dart';

import '../architecture/bloc/base_state.dart';

class ThemeChangedState extends BaseState {
  final ThemeData theme;

  ThemeChangedState({
    required this.theme,
  });

  @override
  List get props => [theme];
}
