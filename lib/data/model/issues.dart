import 'package:flutter_github_graphql/data/model/issue_edge.dart';
import 'package:flutter_github_graphql/data/model/page_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issues.g.dart';

@JsonSerializable()
class Issues {
  PageInfo pageInfo;
  List<IssueEdge> edges;

  Issues(this.pageInfo, this.edges);

  factory Issues.fromJson(Map<String, dynamic> json) => _$IssuesFromJson(json);

  Map<String, dynamic> toJson() => _$IssuesToJson(this);
}
