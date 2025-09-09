import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/presentations/home_view.dart';
import 'package:flutter_application_3/presentations/screens/loginsignup_screen.dart';
import 'package:flutter_application_3/providers/todo_provider.dart';
//import 'package:flutter_application_3/presentations/home_view.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_application_3/widgets/todo_card.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final todoProvider = TodoProvider();

//   runApp(
//     ChangeNotifierProvider.value(
//       value: todoProvider,
//       child: MyApp(todoProvider: todoProvider),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final TodoProvider todoProvider;
//   const MyApp({super.key, required this.todoProvider});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await todoProvider.loadTodos();
//     });

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: user != null ? HomeView() : LoginSignupScreen(),
//       //initialRoute: "/login",
//       routes: {
//         "/login": (context) => LoginSignupScreen(),
//         "/home": (context) => HomeView(),
//       },
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider()..initialize(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: user != null ? HomeView() : LoginSignupScreen(),
      routes: {
        '/login': (context) => LoginSignupScreen(),
        '/home': (context) => HomeView(),
      },
    );
  }
}
