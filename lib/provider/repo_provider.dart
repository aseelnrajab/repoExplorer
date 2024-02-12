import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/branch.dart';
import '../model/repository.dart';

class RepositoryProvider extends ChangeNotifier {
  List<Repository> _repositories = [];
  List<Branch> _branches = [];
  bool _loading = false;
  List<Repository> _filteredRepositories = [];

  final _error = false;

  List<Repository> get repositories => _repositories;

  List<Repository> get filteredRepositories => _filteredRepositories;

  List<Branch> get allBranches => _branches;

  bool get loading => _loading;

  bool get error => _error;

  Future<void> fetchRepositories() async {
    _loading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse('https://api.github.com/repositories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _repositories =
            data.map((repoData) => Repository.fromJson(repoData)).toList();
        _filteredRepositories = _repositories;
        notifyListeners();
      } else {
        throw Exception('Failed to load repositories');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void sortRepositories(String sortBy) {
    _filteredRepositories = repositories;
    switch (sortBy) {
      case 'name':
        _repositories.sort((a, b) =>
            a.repoName.toLowerCase().compareTo(b.repoName.toLowerCase()));
        break;
      case 'description':
        _repositories.sort((a, b) => a.description.compareTo(b.description));
        break;
    }
    notifyListeners();
  }

  void filterRepositoriesByOwner(String owner) {
    _filteredRepositories = repositories;
    if (owner.isNotEmpty) {
      _filteredRepositories = _repositories
          .where((repository) => repository.owner.login
              .toLowerCase()
              .contains(owner.toLowerCase()))
          .toList();
    } else {
      _filteredRepositories = _repositories;
    }
    notifyListeners();
  }

  void searchRepos(String val) {
    _filteredRepositories = repositories;
    if (val.isNotEmpty) {
      _filteredRepositories = _repositories
          .where((repository) =>
              repository.repoName.toLowerCase().contains(val.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      _filteredRepositories = _repositories;
      notifyListeners();
    }
  }

  Future<void> fetchBranches(String fullName) async {
    _loading = true;
    try {
      final branchResponse = await http
          .get(Uri.parse('https://api.github.com/repos/$fullName/branches'));
      if (branchResponse.statusCode == 200) {
        final List<dynamic> data = json.decode(branchResponse.body);
        _branches =
            data.map((branchData) => Branch.fromJson(branchData)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load branch');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
