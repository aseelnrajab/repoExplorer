import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:repo_explorer_app/provider/repo_provider.dart';
import 'package:repo_explorer_app/provider/theme_provider.dart';
import 'package:repo_explorer_app/screens/repo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => RepositoryProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                home: const RepoMainPage(),
              );
            })));
  }
}
