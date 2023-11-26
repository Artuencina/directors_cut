//Go router
import 'package:directors_cut/features/scenes/ui/pages/scenes.dart';
import 'package:directors_cut/main.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
]);
