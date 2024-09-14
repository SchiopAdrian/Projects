import 'package:flutter/material.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LoginMailWidget extends StatefulWidget {
  final Mail? mail;
  final String to;
  final String cc;
  final String bcc;
  final String subject;
  final String content;
  final DateTime dateAndTimeSend;
  final DateTime dateAndTimeReminder;
  final String id;

  LoginMailWidget({
    this.mail,
    required this.to,
    required this.cc,
    required this.bcc,
    required this.subject,
    required this.content,
    required this.dateAndTimeSend,
    required this.dateAndTimeReminder,
    required this.id,
  });

  @override
  State<LoginMailWidget> createState() => _LoginMailWidgetState();
}

class _LoginMailWidgetState extends State<LoginMailWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:SingleChildScrollView(
      
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  var id = Uuid();
                  final providerAuth = Provider.of<UserProvider>(context, listen: false);
                  final provider = Provider.of<MailProvider>(context, listen: false);
                  final isEditing = widget.mail != null;
                  if (isEditing) {
                    final mail = Mail(
                        subject: widget.subject,
                        content: widget.content,
                        userEmail: emailController.text,
                        userPassword: passwordController.text,
                        to: widget.to,
                        dateAndTimeSend: widget.dateAndTimeSend,
                        cc: widget.cc,
                        bcc: widget.bcc,
                        id:  widget.mail!.id,
                        dateAndTimeReminder: widget.dateAndTimeReminder,
                        idUser: providerAuth.userId!);
                    provider.editMail(mail, widget.mail!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    final mail = Mail(
                        subject: widget.subject,
                        content: widget.content,
                        userEmail: emailController.text,
                        userPassword: passwordController.text,
                        to: widget.to,
                        dateAndTimeSend: widget.dateAndTimeSend,
                        cc: widget.cc,
                        bcc: widget.bcc,
                        id: id.v4(),
                        dateAndTimeReminder: widget.dateAndTimeReminder,
                        idUser: providerAuth.userId!);
                    provider.addMail(mail);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      )
    ); 
  }
}
