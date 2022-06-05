// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../../data/model/issue_edge.dart' as _i5;
import '../../presentation/home_screen/home_screen.dart' as _i1;
import '../../presentation/issue_details_screen/issue_details_screen.dart'
    as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i3.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i1.HomeScreen());
    },
    IssueDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<IssueDetailsRouteArgs>();
      return _i3.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i2.IssueDetailsScreen(args.issue, key: args.key));
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig('/#redirect',
            path: '/', redirectTo: '/Home-screen', fullMatch: true),
        _i3.RouteConfig(HomeScreen.name, path: '/Home-screen'),
        _i3.RouteConfig(IssueDetailsRoute.name,
            path: 'Issue-Details', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreen extends _i3.PageRouteInfo<void> {
  const HomeScreen() : super(HomeScreen.name, path: '/Home-screen');

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.IssueDetailsScreen]
class IssueDetailsRoute extends _i3.PageRouteInfo<IssueDetailsRouteArgs> {
  IssueDetailsRoute({required _i5.IssueEdge issue, _i4.Key? key})
      : super(IssueDetailsRoute.name,
            path: 'Issue-Details',
            args: IssueDetailsRouteArgs(issue: issue, key: key));

  static const String name = 'IssueDetailsRoute';
}

class IssueDetailsRouteArgs {
  const IssueDetailsRouteArgs({required this.issue, this.key});

  final _i5.IssueEdge issue;

  final _i4.Key? key;

  @override
  String toString() {
    return 'IssueDetailsRouteArgs{issue: $issue, key: $key}';
  }
}
