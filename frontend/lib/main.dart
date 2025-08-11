import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Change_disability/change_disability_bloc.dart';
import 'package:lingua_arv1/bloc/Change_password/change_password_bloc.dart';
import 'package:lingua_arv1/bloc/Login/login_bloc.dart';
import 'package:lingua_arv1/bloc/Otp/otp_bloc.dart';
import 'package:lingua_arv1/bloc/Register/register_bloc.dart';
import 'package:lingua_arv1/repositories/Register_repositories/register_repository_impl.dart';
import 'package:lingua_arv1/repositories/change_disability_repositories/change_disability_repository_impl.dart';
import 'package:lingua_arv1/repositories/change_password_repositories/reset_password_repository_impl.dart';
import 'package:lingua_arv1/repositories/login_repositories/login_repository_impl.dart';
import 'package:lingua_arv1/repositories/otp_repositories/otp_repository_impl.dart';
import 'package:lingua_arv1/screens/settings/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:lingua_arv1/screens/splash/splash_screen.dart';
import 'package:lingua_arv1/screens/home/home_screen.dart';
import 'package:lingua_arv1/screens/get_started/get_started_page1.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(LoginRepositoryImpl()),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(RegisterRepositoryImpl()),
          ),
          BlocProvider(create: (context) => OtpBloc(OtpRepositoryImpl())),
          BlocProvider(
              create: (context) => ChangePasswordBloc(PasswordRepositoryImpl(),
                  resetPasswordRepository: null)),
          BlocProvider(
            create: (context) => ChangeDisabilityBloc(
              DisabilityRepositoryImpl(),
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Jost', brightness: Brightness.light),
          darkTheme: ThemeData(fontFamily: 'Jost', brightness: Brightness.dark),
          themeMode: themeProvider.themeMode,
          home: SplashScreen(),
        );
      },
    );
  }
}

class AppWrapper extends StatelessWidget {
  final bool isLoggedIn;

  const AppWrapper({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Jost', brightness: Brightness.light),
          darkTheme: ThemeData(fontFamily: 'Jost', brightness: Brightness.dark),
          themeMode: themeProvider.themeMode,
          home: isLoggedIn ? HomeScreen() : GetStartedPage1(),
        );
      },
    );
  }
}
