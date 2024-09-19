import 'package:flutter/material.dart';

import '../services/shared_prefs.dart';
import 'error.dart';
import 'home.dart';
import 'loading.dart';
import 'detail.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIsFirstLaunch(), // async work
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingScreen();
          default:
            if (snapshot.hasError) {
              return const ErrorScreen();
            } else if (snapshot.data != null && snapshot.data!) {
              return const DetailScreen(id: '2');
              //context.go('details/2')
            } else {
              return const HomeScreen();
            }
        }
      },
    );
  }

  Future<bool> checkIsFirstLaunch() async {
    bool isFirstLaunch =
        await SharedPrefs().getBoolValue(SharedPrefs.isFirstLaunchKey);

    if (!isFirstLaunch) {
      await SharedPrefs().setBoolValue(SharedPrefs.isFirstLaunchKey, true);
      return false;
    }

    return true;
  }
}
