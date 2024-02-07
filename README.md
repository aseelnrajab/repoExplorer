# repo_explorer_app

A Flutter app which fetches a list of GitHub repositories using the GitHub API and displays them in
a scrollable list view. Each repository item in the list should display the repository's name,
description, owner's username, and owner's avatar image. Each repository should have a detail page
where the user can see the list of branches a repository contains.

and a lot of functionalities as: filtering the repos, sorting By repo name & description.

## App Structure

This project has 3 type of folder:

1. models - The models folder contains files each with a custom class of an object widely used
   throughout the app.
2. provider - Contains store(s) for state-management of the app, to connect the reactive data of
   your application with the UI.
3. UI screens - The screens folder holds different screen of the app.

## Getting Started

1. clone the repo to your local folder.
2. make sure you've updated your flutter & dart sdk
3. flutter pub get
4. you need to run flutter pub run build_runner build to trigger code generation for libraries that
   rely on annotations and code generation, ensuring that your Dart code is up-to-date and properly
   generated based on your annotations.Libraries like freezed_annotation and json_serializable
5. run your app
