import 'package:flutter_github_graphql/data/enum/order_by.dart';
import 'package:flutter_github_graphql/domain/repositories/home_screen_repository.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/base_usecase.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/filter_issues.dart';
import '../../data/model/get_issues_list_response.dart';
import '../../infrastructure/architecture/data/base_error.dart';
import '../../infrastructure/architecture/data/base_response.dart';

@injectable
class HomeScreenUseCase extends BaseUseCase<HomeScreenRepository> {
  HomeScreenUseCase(HomeScreenRepository repository) : super(repository);

  Future<BaseResponse<IssuesResponse, BaseError>> getData({
    String? after,
    FilterIssues? filters,
    OrderBy orderBy = OrderBy.asc,
  }) async =>
      repository.getDate(after: after, filters: filters, orderBy: orderBy);
}
