import 'package:json_annotation/json_annotation.dart';

import '../enum/issue_status.dart';

part 'filter_issues.g.dart';

@JsonSerializable()
class FilterIssues {
  List<IssueStatus>? states;
  String? createdBy;
  String? assignee;

  FilterIssues({this.states, this.createdBy, this.assignee}) {
    states ??= [IssueStatus.open, IssueStatus.closed];
  }

  factory FilterIssues.fromJson(Map<String, dynamic> json) =>
      _$FilterIssuesFromJson(json);

  Map<String, dynamic> toJson() => _$FilterIssuesToJson(this);
}
