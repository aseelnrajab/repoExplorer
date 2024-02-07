import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/repository.dart';
import '../provider/repo_provider.dart';

class RepositoryDetailPage extends StatelessWidget {
  final Repository repository;

  const RepositoryDetailPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final repositoryProvider =
        Provider.of<RepositoryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.ownerUsername.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 200.h,
              width: 200.w,
              child: CircleAvatar(
                backgroundImage: NetworkImage(repository.owner.avatarUrl),
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            Center(
              child: Text(
                repository.owner.login.toUpperCase(),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(26.w),
              child: Text(
                repository.description,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Branches:',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: repositoryProvider.fetchBranches(repository.fullName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading branches'));
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: repositoryProvider.allBranches.length,
                      itemBuilder: (context, index) {
                        final branch = repositoryProvider.allBranches[index];
                        return ListTile(
                          title: Text(
                            branch.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          selectedTileColor: Colors.purple[100],
                          selected: true,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5.h,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
