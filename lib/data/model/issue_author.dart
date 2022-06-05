import 'package:json_annotation/json_annotation.dart';

part 'issue_author.g.dart';

@JsonSerializable()
class IssueAuthor {
  @JsonKey(name: 'login')
  String name;

  @JsonKey(name: "avatarUrl")
  String imageUrl;

  IssueAuthor(this.name, this.imageUrl);

  factory IssueAuthor.fromJson(Map<String, dynamic> json) =>
      _$IssueAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$IssueAuthorToJson(this);
}
