enum OrderBy { asc, desc }

extension OrderByExtension on OrderBy {
  String get stringValue => this == OrderBy.asc ? "ASC" : "DESC";
}
