import 'package:flutter_github_graphql/data/enum/issue_status.dart';
import 'package:flutter_github_graphql/data/model/issue_author.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_node.g.dart';

@JsonSerializable()
class IssueNode {
  String title;
  String bodyText;
  String url;
  IssueStatus state;
  IssueAuthor? author;
  DateTime createdAt;

  IssueNode(
    this.title,
    this.url,
    this.state,
    this.bodyText,
    this.author,
    this.createdAt,
  );

  /// Connect the generated [_$IssueNodeJson] function to the `fromJson`
  /// factory.
  factory IssueNode.fromJson(Map<String, dynamic> json) =>
      _$IssueNodeFromJson(json);

  /// Connect the generated [_$IssueNodeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$IssueNodeToJson(this);
}
