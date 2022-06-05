import 'package:auto_route/annotations.dart';
import 'package:flutter_github_graphql/infrastructure/routing/route_paths.dart';

import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/issue_details_screen/issue_details_screen.dart';

///Will hold all the routes in our app
@CupertinoAutoRouter(
  replaceInRouteName: 'Page|Dialog,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      path: RoutePaths.homeScreen,
      initial: true,
    ),
    AutoRoute(
      page: IssueDetailsScreen,
      name: "IssueDetailsRoute",
      path: RoutePaths.issueDetails,
      fullMatch: true,
    ),
  ],
)
// extend the generated private router
class $AppRouter {}
