import 'package:flutter/material.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/provider/user_provider.dart'; // Import the UserProvider
import 'package:provider/provider.dart'; // Import the Provider package
import 'sign_up_page.dart'; // Import your SignUpPage

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.checkAuthentication();
    if (userProvider.userId != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> signIn() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final emailProvider = Provider.of<MailProvider>(context, listen: false);
    bool success = await userProvider.signIn(
      emailController.text,
      passwordController.text,
      emailProvider,
      taskProvider
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home on success
    } else {
      setState(() {
        message = 'Sign in failed. Please check your credentials and internet connectivity.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signIn(),
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
            SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(color: Colors.red), 
              ),
          ],
        ),
      ),
    );
  }
}
