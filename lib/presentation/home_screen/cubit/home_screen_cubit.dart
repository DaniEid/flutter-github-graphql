import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_github_graphql/data/enum/order_by.dart';
import 'package:flutter_github_graphql/data/model/filter_issues.dart';
import 'package:flutter_github_graphql/data/model/page_info.dart';
import 'package:flutter_github_graphql/domain/usecase/home_screen_usecase.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_cubit.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/enum/issue_status.dart';
import '../../../data/model/issue_edge.dart';
import 'home_screen_state.dart';

///Home Cubit that will have the repo and all the requests
class HomeScreenCubit extends BaseCubit {
  HomeScreenCubit(this.useCase) : super(InitialState());

  final HomeScreenUseCase useCase;

  final ScrollController scrollController = ScrollController();
  final List<IssueStatus> status = [];
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();

  BehaviorSubject<List<IssueStatus>> statusFilterSubject = BehaviorSubject();

  Stream<List<IssueStatus>> get statusFilterStream =>
      statusFilterSubject.stream;

  PublishSubject<List<IssueEdge>> visitedIssueSubject = PublishSubject();
  Stream<List<IssueEdge>> get visitedIssueStream => visitedIssueSubject.stream;

  List<IssueEdge> issues = [];

  List<IssueEdge> visitedIssues = [];

  bool isVisited(IssueEdge issue) => visitedIssues.contains(issue);

  bool isDesc = false;
  PageInfo? pageInfo;

  FilterIssues? filterIssues;

  bool isBusy = false;

  Future<void> getDate({String? lastIssue}) async {
    isBusy = true;
    if (lastIssue == null) {
      emit(LoadingState());
    } else {
      emitData(true);
    }

    final assignee = assigneeController.text;
    final createdBy = createdByController.text;
    if (createdBy.isNotEmpty || assignee.isNotEmpty || status.isNotEmpty) {
      filterIssues = FilterIssues(
        assignee: assignee.isNotEmpty ? assignee : null,
        createdBy: createdBy.isNotEmpty ? createdBy : null,
        states: status.isNotEmpty ? status : null,
      );
    }

    final response = await useCase.getData(
      after: lastIssue,
      orderBy: isDesc ? OrderBy.desc : OrderBy.asc,
      filters: filterIssues,
    );
    if (response.success) {
      issues += response.data!.data.edges;
      pageInfo = response.data!.data.pageInfo;

      emitData(false);
    } else {
      emit(FailureState(response.error));
    }

    isBusy = false;
  }

  void emitData(bool isMoreData) {
    if (isMoreData) {
      emit(LoadingMoreState<List<IssueEdge>>(issues));
    } else {
      emit(SuccessState<List<IssueEdge>>(issues));
    }
  }

  ///check if we have to fetch new data
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0 && !isBusy) {
        if (pageInfo != null && pageInfo!.hasNextPage) {
          getDate(lastIssue: pageInfo!.endCursor!);
        }
      }
    }
    return false;
  }

  void handleSortingByDate() {
    isDesc = !isDesc;
    clearData();
    getDate();
  }

  void handleFilterIssue() {}

  void clearData() {
    issues.clear();
    pageInfo = null;
  }

  Future<void> clearFilter() async {
    filterIssues = null;
    assigneeController.text = "";
    createdByController.text = "";
    status.clear();
    clearData();
    await getDate();
  }

  void handleStatusFilter(IssueStatus newStatus) {
    final index = status.indexOf(newStatus);
    if (index != -1) {
      status.removeAt(index);
    } else {
      status.add(newStatus);
    }

    statusFilterSubject.add(status);
  }

  void addToVisited(IssueEdge issue) {
    if (!visitedIssues.contains(issue)) {
      visitedIssues.add(issue);
      visitedIssueSubject.add(visitedIssues);
    }
  }
}
