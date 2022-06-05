import 'dart:developer';

import 'package:flutter_github_graphql/data/enum/order_by.dart';
import 'package:flutter_github_graphql/data/model/get_issues_list_response.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/data/base_error.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/data/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../model/filter_issues.dart';
import 'graphql_service.dart';

@injectable
class GithubServices {
  final GraphQLService service;

  GithubServices(this.service);

  Future<BaseResponse<IssuesResponse, BaseError>> getIssueList({
    String? after,
    FilterIssues? filters,
    OrderBy? orderBy = OrderBy.asc,
  }) async {
    await Future.delayed(const Duration(seconds: 3));

    const query = r'''
         query($after: String, $states: [IssueState!],
      $createdBy: String,
      $assignee: String,
      $orderBy: OrderDirection!
        ) {
    repository(owner:"flutter", name:"flutter") {
    
     issues(first: 10, 
            after: $after, 
            filterBy: {states: $states,
                       createdBy: $createdBy,
                       assignee: $assignee},
            orderBy:  {field: CREATED_AT,
                       direction: $orderBy} ) {
     pageInfo {
        hasNextPage
        endCursor
      }
        edges {
          cursor
          node {
          title
          bodyText
          url
          state
          createdAt
          author {
            login
            avatarUrl
          }
         }
       }
      }
    }
  }
  ''';

    Map<String, dynamic> variables = {
      "after": after,
      "orderBy": orderBy!.stringValue,
    };

    variables
        .addAll(filters != null ? filters.toJson() : FilterIssues().toJson());

    final response = await service.performQuery(
      query,
      variables: variables,
    );

    log("$response");

    if (response.success) {
      return BaseResponse.completed(IssuesResponse.fromJson(response.data));
    } else {
      log("${response.error!.message}");
      return BaseResponse.error(response.error);
    }
  }
}
