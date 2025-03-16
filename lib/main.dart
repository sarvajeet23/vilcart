import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/core/error/app_bloc_observer.dart';
import 'package:vilcart/view/dashboard/dash_board_page.dart';
import 'package:vilcart/view/auth/auth_page.dart';
import 'package:vilcart/view/auth/bloc/login_bloc.dart';
import 'package:vilcart/view/product/bloc/product_bloc.dart';
import 'package:vilcart/view/auth/repository/auth_repository.dart';
import 'package:vilcart/view/product/repository/customer_repository.dart';
import 'package:vilcart/view/product/repository/stock_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  String initialRoute = await getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool("remember_me") ?? false;
  String? token = prefs.getString("auth_token");
  bool isValid = false;
  if (rememberMe && token != null && token.isNotEmpty) {
    isValid = !JwtDecoder.isExpired(token);
  }
  return isValid ? '/products' : '/';
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(
          create:
              (context) =>
                  ProductBloc(ProductRepository(), CustomerRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vilcart App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => LoginScreen(),
          '/products': (context) => DashBoardPage(),
        },
      ),
    );
  }
}
