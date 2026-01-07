import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/core/di/injection_container.dart' as di;
import 'package:interview_test/core/routing/app_router.dart';
import 'package:interview_test/core/theme/app_theme.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:interview_test/features/product/presentation/bloc/product_bloc.dart';
import 'package:interview_test/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:interview_test/features/theme/presentation/bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ProductBloc>()),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                title: 'Product Dashboard',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                routerConfig: AppRouter.createRouter(context),
              );
            },
          );
        },
      ),
    );
  }
}
