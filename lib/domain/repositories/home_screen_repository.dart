import 'package:flutter_github_graphql/infrastructure/architecture/base_repository.dart';

import '../../data/enum/order_by.dart';
import '../../data/model/filter_issues.dart';
import '../../data/model/get_issues_list_response.dart';
import '../../infrastructure/architecture/data/base_error.dart';
import '../../infrastructure/architecture/data/base_response.dart';

abstract class HomeScreenRepository extends BaseRepository {
  Future<BaseResponse<IssuesResponse, BaseError>> getDate({
    String? after,
    FilterIssues? filters,
    OrderBy? orderBy,
  });
}
