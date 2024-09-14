import 'package:flutter/material.dart';
import 'package:mobile_ui/main.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/services/auth_service.dart';
import 'package:mobile_ui/ui/task_editing_pange.dart';
import 'package:mobile_ui/ui/mail_editing_page.dart';
import 'package:mobile_ui/widget/calendar_widget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {


  final AuthService authService = AuthService();
  
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Mailender"),
      centerTitle: true,
      leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Call the logout method from your AuthService
              authService.signOut();
              // Navigate to the login page or handle the UI update accordingly
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
      actions: [ ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MailEditingPage())),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(0, 79, 5, 92),
          shadowColor: const Color.fromARGB(0, 79, 5, 92),
          side: BorderSide(
            width: 1.0,
            color: Colors.black
          )
        ),
        icon: Icon(Icons.email),
        label: Text("Email"),
        )],
    ),
    body: CalendarWidget(),
    floatingActionButton: FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white, 
      ),
      backgroundColor: Colors.red,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TaskEditingPage())
      ),
    ),
  );
}

