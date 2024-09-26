import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/url_details.dart';
import 'screens/home.dart';
import 'screens/detail.dart';
import 'screens/details.dart';
import 'services/device_info_client.dart';
import 'services/shared_prefs.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      redirect: (context, state) async {
        try {
          bool wasLaunchedBefore = await SharedPrefs()
              .getBoolValue(SharedPrefs.wasLaunchedBeforeKey);

          if (!wasLaunchedBefore) {
            await SharedPrefs()
                .setBoolValue(SharedPrefs.wasLaunchedBeforeKey, true);

            UrlDetails details = await DeviceInfoClient.checkDeviceInfo();

            return details.url;
          }
        } catch (e) {
          // ignore: avoid_print
          print(e.toString());
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                return DetailScreen(id: state.pathParameters['id']);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
