import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/auth/auth_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';
import 'package:grocery_management_frontend/services/managers/auth_manager.dart';
import 'package:grocery_management_frontend/services/managers/budget_manager.dart';
import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';
import 'package:grocery_management_frontend/services/managers/store_manager.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';
import 'package:grocery_management_frontend/screens/auth/login_screen.dart';
import 'package:grocery_management_frontend/screens/auth/register_screen.dart';
import 'package:grocery_management_frontend/screens/portal/portal_screen.dart';
import 'package:grocery_management_frontend/services/app_config.dart';
import 'package:grocery_management_frontend/services/startup_services.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StartupServices.startServices();

  const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

  await AppConfig.load(environment);

  ApiClient().init(AppConfig.baseUrl);

  runApp(const ToastificationWrapper(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthManager()),
        RepositoryProvider(create: (context) => PantryManager()),
        RepositoryProvider(create: (context) => StoreManager()),
        RepositoryProvider(create: (context) => TripManager()),
        RepositoryProvider(create: (context) => BudgetManager()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authManager: context.read<AuthManager>()),
          ),
          BlocProvider(create: (context) => PortalBloc()),
        ],
        child: MaterialApp(
          title: 'Grocery Management',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const PortalScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const PortalScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
