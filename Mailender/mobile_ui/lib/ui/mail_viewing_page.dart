import 'package:flutter/material.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/ui/mail_editing_page.dart';
import 'package:mobile_ui/utils/utils.dart';
import 'package:provider/provider.dart';

class MailViewingPage extends StatelessWidget {
  final Mail mail;

  const MailViewingPage({
    Key? key,
    required this.mail,
  }):super(key: key);

  Widget buildDateTime(Mail mail){
    return Column(
      children: [
        buildDate('SendAt', mail.dateAndTimeSend),
        buildDate('ReminderAt', mail.dateAndTimeReminder),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
    leading: CloseButton(),
    actions: buildViewingActions(context, mail),
  ),
  body: ListView(
    padding: EdgeInsets.all(32),
    children: <Widget>[
      buildDateTime(mail),
      SizedBox(height: 24,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            mail.to,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 24),
      // CC Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CC:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            mail.cc,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      const SizedBox(height: 24),
      // BCC Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BCC:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            mail.bcc,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      SizedBox(height: 32),
      // Subject Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            mail.subject,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      
      
      const SizedBox(height: 24),
      // Content Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            mail.content,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    ],
  ),
);
  
  List<Widget> buildViewingActions(BuildContext context, Mail mail) => [
    IconButton(
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MailEditingPage(mail: mail,)
          )
      ), 
      icon: Icon(Icons.edit)
      ),
      IconButton(
        onPressed: () {
          final provider = Provider.of<MailProvider>(context, listen: false);
          provider.deleteMail(mail);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.delete)
      )
  ];
  
  buildDate(String title, DateTime date) => buildHeader(
    header: title, 
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            Utils.toDate(date),
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            Utils.toTime(date),
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
               
            ),
          ),
        ),
      ],
      )
    
    );

  Widget buildHeader({
    required String header,
    required Widget child
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    
    children: [
      Text(header, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      child
    ],
  );
}