import 'package:flutter_github_graphql/data/model/issue_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_edge.g.dart';

@JsonSerializable()
class IssueEdge {
  String cursor;
  IssueNode node;

  IssueEdge(this.cursor, this.node);

  factory IssueEdge.fromJson(Map<String, dynamic> json) =>
      _$IssueEdgeFromJson(json);

  Map<String, dynamic> toJson() => _$IssueEdgeToJson(this);
}
