import 'package:json_annotation/json_annotation.dart';

import 'issues.dart';

part 'get_issues_list_response.g.dart';

@JsonSerializable()
class IssuesResponse {
  @JsonKey(fromJson: getData, name: "repository")
  Issues data;

  IssuesResponse(this.data);

  ///this function will remove nested opbjects
  static getData(Map<String, dynamic> json) {
    final issueJson = json["issues"];

    return Issues.fromJson(issueJson);
  }

  factory IssuesResponse.fromJson(Map<String, dynamic> json) =>
      _$IssuesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IssuesResponseToJson(this);
}
