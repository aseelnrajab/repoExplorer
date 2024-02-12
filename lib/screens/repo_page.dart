import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:repo_explorer_app/screens/repo_details_page.dart';

import '../provider/repo_provider.dart';
import '../provider/theme_provider.dart';

class RepoMainPage extends StatefulWidget {
  const RepoMainPage({super.key});

  @override
  State<RepoMainPage> createState() => _RepoMainPageState();
}

class _RepoMainPageState extends State<RepoMainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepositoryProvider>(context, listen: false)
          .fetchRepositories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repositoryProvider = Provider.of<RepositoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Repositories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              repositoryProvider.fetchRepositories();
              repositoryProvider.filterRepositories(''); //clear the filtered
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<RepositoryProvider>(
        builder: (context, repositoryProvider, child) {
          if (repositoryProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (repositoryProvider.error) {
            return const Center(child: Text('Error loading repositories'));
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: EasySearchBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text('Search'),
                    leading: Row(children: [
                      IconButton(
                          onPressed: () {
                            _onFilterPressed();
                          },
                          icon: const Icon(Icons.filter_alt_rounded)),
                      IconButton(
                          onPressed: () {
                            _onSortPressed();
                          },
                          icon: const Icon(Icons.sort))
                    ]),
                    onSearch: (val) {
                      repositoryProvider.filterRepositories(val);
                    },
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: repositoryProvider.filteredRepositories.length,
                    itemBuilder: (context, index) {
                      final repository =
                          repositoryProvider.filteredRepositories[index];
                      return ListTile(
                        title: Text(
                          repository.owner.login,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          repository.description,
                          style: const TextStyle(color: Colors.black),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        selectedTileColor: Colors.purple[100],
                        selected: true,
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(repository.owner.avatarUrl),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RepositoryDetailPage(repository: repository),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5.h,
                      );
                    },
                  ),
                )
              ]),
            );
          }
        },
      ),
    );
  }

  void _onSortPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Repositories'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Sort by Name'),
              leading: const Icon(Icons.sort_by_alpha),
              onTap: () {
                Provider.of<RepositoryProvider>(context, listen: false)
                    .sortRepositories('name');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Description'),
              leading: const Icon(Icons.sort_outlined),
              onTap: () {
                Provider.of<RepositoryProvider>(context, listen: false)
                    .sortRepositories('description');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onFilterPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Repositories by Owner'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter owner username',
          ),
          onChanged: (value) {
            Provider.of<RepositoryProvider>(context, listen: false)
                .filterRepositoriesByOwner(value);
          },
        ),
      ),
    );
  }
}
