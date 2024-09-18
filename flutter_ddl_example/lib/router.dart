import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/detail.dart';
import 'screens/details.dart';
import 'screens/home.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
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
