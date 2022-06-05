import 'package:json_annotation/json_annotation.dart';

enum IssueStatus {
  @JsonValue("OPEN")
  open,
  @JsonValue("CLOSED")
  closed
}

extension IssueStatusExtension on IssueStatus {
  String get stringValue => this == IssueStatus.open ? "Open" : "Closed";
}
