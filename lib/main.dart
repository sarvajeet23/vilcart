import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/app_bloc_observer.dart';
import 'package:vilcart/dash_board_page.dart';
import 'package:vilcart/repository/stock_repository.dart';
import 'package:vilcart/view/auth/auth_page.dart';
import 'package:vilcart/view/auth/bloc/login_bloc.dart';
import 'package:vilcart/view/product/product_bloc.dart';
import 'package:vilcart/view/product_page.dart';

import 'repository/auth_repository.dart';
import 'repository/customer_repository.dart'; // Assuming you have this repository for fetching customers

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),

        // Provide ProductBloc, passing both ProductRepository and CustomerRepository
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
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/products': (context) => DashBoardPage(),
        },
      ),
    );
  }
}
