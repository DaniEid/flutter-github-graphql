import 'package:flutter/material.dart';
import 'package:flutter_github_graphql/data/enum/issue_status.dart';
import 'package:flutter_github_graphql/presentation/components/ui_components.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/model/issue_edge.dart';

class IssueDetailsScreen extends StatelessWidget {
  const IssueDetailsScreen(this.issue, {Key? key}) : super(key: key);

  final IssueEdge issue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issues Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              issueGeneralInfo(context),
              authorSection(context),
              issueBody,
            ],
          ),
        ),
      ),
    );
  }

  Widget issueGeneralInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          issue.node.title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Status: ${issue.node.state.stringValue}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.apply(color: Colors.green.shade900),
        ),
        Text(
          "create date: ${DateFormat.yMMMEd().format(issue.node.createdAt.toLocal())}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.apply(color: Colors.green.shade900),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget authorSection(BuildContext context) {
    final author = issue.node.author;
    if (author == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: UIComponents.buildImage(author.imageUrl)),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Author Name: ${author.name}"),
              GestureDetector(
                onTap: () async {
                  final url = issue.node.url;
                  if (await canLaunchUrlString(url)) {
                    launchUrlString(url);
                  }
                },
                child: Text(
                  "Issue Url: ${issue.node.url}",
                  style: Theme.of(context).textTheme.bodyText1?.apply(
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget get issueBody => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(issue.node.bodyText),
      );
}
