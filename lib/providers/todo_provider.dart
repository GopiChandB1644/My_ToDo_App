import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/todo_model.dart';
import 'package:flutter_application_3/presentations/home_view.dart';
import 'package:intl/intl.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider();
  String userName = '';
  String email = '';
  String password = '';
  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;
  bool obscureText = true;

  TextEditingController dueDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await loadTodos(); // Load todos only if logged in
    }
  }

  void visubility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  /// ================= Date Picker =================
  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _dueDate = pickedDate;
      dueDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners();
    }
  }

  bool formValidator() {
    return _formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void savevalue() {
    _formKey.currentState!.save();
    notifyListeners();
  }

  /// ================= Firestore Sync =================
  Future<void> loadTodos() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("⚠️ No user logged in, skipping loadTodos.");
      return;
    }

    try {
      setLoading(true);
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .get();

      _todos = snapshot.docs
          .map((doc) => TodoModel.fromJson(doc.data(), id: doc.id))
          .toList();

      //notifyListeners();
    } catch (e) {
      print("❌ Error loading todos: $e");
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newTodo = TodoModel(
      id: '',
      title: title,
      dueDate: dueDateController.text,
      isDone: false,
    );

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .add(newTodo.toJson());

    newTodo.id = docRef.id;
    _todos.add(newTodo);
    notifyListeners();
  }

  Future<void> toggleStatus(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final todo = _todos[index];
    todo.isDone = !todo.isDone;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(todo.id)
        .update({'isDone': todo.isDone});

    notifyListeners();
  }

  Future<void> todelete(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docId = _todos[index].id;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(docId)
        .delete();

    _todos.removeAt(index);
    notifyListeners();
  }

  Future<void> insertTodoAt(int index, TodoModel todo) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .add(todo.toJson());

    todo.id = docRef.id;
    _todos.insert(index, todo);
    notifyListeners();
  }

  Future<void> logout() async {
    _todos.clear(); // Clear local state
    notifyListeners(); // Update UI
    await FirebaseAuth.instance.signOut();
  }

  void resetDate() {
    _dueDate = null;
    dueDateController.clear();
    notifyListeners();
  }

  /// ================= Auth =================
  signup(BuildContext context, String Email, String Password) async {
    try {
      setLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: Password,
      );
      await loadTodos();
      emailController.clear();
      passwordController.clear();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeView()));
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account already exists for this email.")),
        );
        emailController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setLoading(false);
    }
  }

  login(BuildContext context, String email, String password) async {
    try {
      setLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await loadTodos();
      emailController.clear();
      passwordController.clear();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeView()));
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid email or password. Please try again."),
          ),
        );
        passwordController.clear();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login failed: ${e.message}")));
      }
    } finally {
      setLoading(false);
    }
  }

  forgotPassword(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter your email first")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "If an account exists for $email, a reset link has been sent. Check inbox or spam.",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred, please try again.")),
      );
    }
  }
}
