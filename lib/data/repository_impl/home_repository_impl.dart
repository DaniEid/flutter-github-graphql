import 'package:flutter_github_graphql/data/data_source/remote/github_services.dart';
import 'package:flutter_github_graphql/domain/repositories/home_screen_repository.dart';
import 'package:injectable/injectable.dart';

import '../../infrastructure/architecture/data/base_error.dart';
import '../../infrastructure/architecture/data/base_response.dart';
import '../enum/order_by.dart';
import '../model/filter_issues.dart';
import '../model/get_issues_list_response.dart';

///Will be responsible to implement the home repository and having the functionality here

@Injectable(as: HomeScreenRepository)
class HomeScreenRepositoryImpl extends HomeScreenRepository {
  final GithubServices services;

  HomeScreenRepositoryImpl(this.services);

  @override
  Future<BaseResponse<IssuesResponse, BaseError>> getDate({
    String? after,
    FilterIssues? filters,
    OrderBy? orderBy,
  }) =>
      services.getIssueList(after: after, filters: filters, orderBy: orderBy);
}
