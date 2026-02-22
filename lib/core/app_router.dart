import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/truck_details_screen.dart';
import '../screens/reviews/add_review_screen.dart';
import '../screens/owner/owner_shell_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const profile = '/profile';
  static const owner = '/owner';
  static const details = '/details/:id';
}

final _supabase = Supabase.instance.client;


final _authRole = AuthRoleRefresh(_supabase);

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,

  
  refreshListenable: _authRole,

  redirect: (context, state) {
    final session = _supabase.auth.currentSession;
    final loggedIn = session != null;

    final path = state.uri.path;
    final goingToAuth = path == AppRoutes.login || path == AppRoutes.signup;


    if (!loggedIn && !goingToAuth) return AppRoutes.login;

  
    if (loggedIn && goingToAuth) {
      if (_authRole.role == 'owner') return AppRoutes.owner;
      return AppRoutes.home;
    }

  
    final role = _authRole.role;
    if (role == null) return null;

   
    if (role == 'owner' && path == AppRoutes.home) return AppRoutes.owner;

    
    if (role != 'owner' && path == AppRoutes.owner) return AppRoutes.home;

    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.owner,
      builder: (context, state) => const OwnerShellScreen(),
    ),
    GoRoute(
      path: AppRoutes.details,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TruckDetailsScreen(truckId: id);
      },
      routes: [
        GoRoute(
          path: 'add-review',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AddReviewScreen(truckId: id);
          },
        ),
      ],
    ),
  ],
);


class AuthRoleRefresh extends ChangeNotifier {
  AuthRoleRefresh(this._client) {
  
    _loadRole();

 
    _sub = _client.auth.onAuthStateChange.listen((_) async {
      await _loadRole();
      notifyListeners();
    });
  }

  final SupabaseClient _client;
  late final StreamSubscription<AuthState> _sub;

  String? _role; 
  String? get role => _role;

  Future<void> _loadRole() async {
    final session = _client.auth.currentSession;

    if (session == null) {
      _role = null;
      return;
    }

    final userId = session.user.id;

    try {
      final data = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final r = (data['role'] as String?)?.toLowerCase().trim();

      _role = (r == 'owner') ? 'owner' : 'customer';
    } catch (_) {
      _role = 'customer';
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}