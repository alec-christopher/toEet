import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_eat/blocs/application_bloc.dart';
import 'package:to_eat/src/screens/filter_screen.dart';
import 'package:to_eat/src/screens/home_screen.dart';
import 'package:to_eat/src/screens/roll_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => HomeScreen(),
          '/roll': (BuildContext context) => RollScreen(),
          '/filter': (BuildContext context) => FilterScreen(),
        },
      ),
    );
  }
}

