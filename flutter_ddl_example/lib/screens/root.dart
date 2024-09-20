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
      future: checkIfWasLaunchedBefore(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingScreen();
          default:
            if (snapshot.hasError) {
              return const ErrorScreen();
            } else if (snapshot.data != null && !snapshot.data!) {
              return const DetailScreen(id: '2');
              //context.go('details/2')
            } else {
              return const HomeScreen();
            }
        }
      },
    );
  }

  Future<bool> checkIfWasLaunchedBefore() async {
    bool wasLaunchedBefore =
        await SharedPrefs().getBoolValue(SharedPrefs.wasLaunchedBeforeKey);

    if (!wasLaunchedBefore) {
      await SharedPrefs().setBoolValue(SharedPrefs.wasLaunchedBeforeKey, true);
      return false;
    }

    return true;
  }
}
