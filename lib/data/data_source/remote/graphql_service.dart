import 'dart:developer';

import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../infrastructure/architecture/data/base_error.dart';
import '../../../infrastructure/architecture/data/base_response.dart';

@singleton
class GraphQLService {
  late final GraphQLClient _client;

  GraphQLService() {
    HttpLink link = HttpLink("https://api.github.com/graphql", defaultHeaders: {
      "Authorization": "bearer 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"
    });

    _client =
        GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore()));
  }

  Future<BaseResponse> performQuery(String query,
      {required Map<String, dynamic> variables}) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variables,
      );

      final result = await _client.query(options);

      if (result.hasException) {
        return BaseResponse.error(
            BaseError(message: result.exception.toString()));
      } else {
        return BaseResponse.completed(result.data);
      }
    } on Exception catch (_, e) {
      return BaseResponse.error(BaseError(message: "No internet connection"));
    }
  }

  Future<QueryResult> performMutation(String query,
      {required Map<String, dynamic> variables}) async {
    MutationOptions options =
        MutationOptions(document: gql(query), variables: variables);

    final result = await _client.mutate(options);

    log(result.toString());

    return result;
  }
}
