import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_graphql/data/enum/issue_status.dart';
import 'package:flutter_github_graphql/infrastructure/architecture/bloc/base_state.dart';
import 'package:flutter_github_graphql/infrastructure/theme/bloc.dart';
import 'package:flutter_github_graphql/presentation/components/ui_components.dart';
import 'package:flutter_github_graphql/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:flutter_github_graphql/presentation/home_screen/cubit/home_screen_state.dart';

import '../../data/model/issue_edge.dart';
import '../../infrastructure/constants/widget_keys.dart';
import '../../infrastructure/routing/app_router.gr.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, BaseState>(
      builder: (context, state) {
        final cubit = context.read<HomeScreenCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Issues list"),
            leading: themeSwitch,
            actions: buildActions(context, cubit),
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: cubit.handleScrollNotification,
            child: Center(
              child: SingleChildScrollView(
                controller: cubit.scrollController,
                child: Column(
                  children: [
                    getBody(context, cubit, state),
                    if (state is LoadingMoreState)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getBody(BuildContext context, HomeScreenCubit cubit, BaseState state) {
    if (state is FailureState) {
      return Column(
        children: [
          Text(
            state.error!.message,
            key: errorTextKey,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              key: retryButtonKey,
              onPressed: () {
                cubit.getDate();
              },
              child: const Text("Retry"))
        ],
      );
    }
    if (state is InitialState) {
      cubit.getDate();
      return const Center(child: CircularProgressIndicator());
    }
    if (state is LoadingState) {
      return const CircularProgressIndicator();
    } else if (state is SuccessState || state is LoadingMoreState) {
      List<IssueEdge> response = [];

      if (state is SuccessState) {
        response = state.response;
      } else if (state is LoadingMoreState) {
        response = state.response;
      }

      if (response.isEmpty) {
        return Text(
          "No Data Available",
          style:
              Theme.of(context).textTheme.bodyLarge?.apply(color: Colors.red),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: response.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final issue = response.elementAt(index);
          return GestureDetector(
            onTap: () {
              cubit.addToVisited(issue);
              context.router.push(
                IssueDetailsRoute(issue: issue),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: cubit.visitedIssueStream,
                    builder: (context, snapshot) {
                      if (cubit.isVisited(issue)) {
                        return Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: const Text('Visited'),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UIComponents.buildImage(
                          issue.node.author?.imageUrl ?? "",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              "Issue",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              issue.node.title,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  ///will return theme switcher between light and dark
  Widget get themeSwitch {
    return BlocBuilder<ThemeCubit, BaseState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Switch.adaptive(
          key: themeModeSwitcherKey,
          value: context.read<ThemeCubit>().isLight,
          onChanged: (newValue) {
            newValue
                ? context.read<ThemeCubit>().changeTheme(AppTheme.blueLight)
                : context.read<ThemeCubit>().changeTheme(AppTheme.blueDark);
          },
        ),
      );
    });
  }

  List<Widget> buildActions(BuildContext context, HomeScreenCubit cubit) {
    return [
      IconButton(
        key: filterButtonKey,
        onPressed: () {
          _modalBottomSheetMenu(context, cubit);
        },
        icon: const Icon(
          Icons.filter_alt,
          color: Colors.blueGrey,
        ),
      ),
      IconButton(
        key: sortButtonKey,
        onPressed: () {
          cubit.handleSortingByDate();
        },
        icon: const Icon(
          Icons.sort,
          color: Colors.blueGrey,
        ),
      ),
    ];
  }

  void _modalBottomSheetMenu(BuildContext context, HomeScreenCubit cubit) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              key: filterSheetKey,
              height: 350,
              decoration: BoxDecoration(
                  color: context.read<ThemeCubit>().isLight
                      ? Colors.grey.shade200
                      : Colors.grey.shade600,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    StreamBuilder<List<IssueStatus>>(
                        stream: cubit.statusFilterStream,
                        initialData: const [],
                        builder: (context, snapshot) {
                          if (snapshot.hasError || snapshot.data == null) {
                            return const SizedBox.shrink();
                          }

                          final status = snapshot.data;
                          return Column(
                            children: [
                              const SizedBox(height: 12),
                              const Text("Select issue status to filter on"),
                              CheckboxListTile(
                                  value: status?.contains(IssueStatus.open),
                                  title: const Text("Open"),
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (check) {
                                    cubit.handleStatusFilter(IssueStatus.open);
                                  }),
                              CheckboxListTile(
                                  value: status?.contains(IssueStatus.closed),
                                  title: const Text("Closed"),
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (check) {
                                    cubit
                                        .handleStatusFilter(IssueStatus.closed);
                                  }),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Filter status based on name "),
                    TextFormField(
                      controller: cubit.createdByController,
                      decoration:
                          const InputDecoration(hintText: "Create by user"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: cubit.assigneeController,
                      decoration:
                          const InputDecoration(hintText: "Assingee name"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                context.popRoute();
                                cubit.clearData();
                                cubit.getDate();
                              },
                              child: const Text("Confirm")),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  context.popRoute();
                                  cubit.clearFilter();
                                },
                                child: const Text("Clear"))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
