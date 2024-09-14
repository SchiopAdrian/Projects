


import 'package:flutter/material.dart';
import 'package:mobile_ui/model/mail.dart';

import 'package:mobile_ui/utils/utils.dart';
import 'package:mobile_ui/widget/login_widget.dart';

class MailEditingPage extends StatefulWidget {
  final Mail? mail;

  const MailEditingPage({
    Key? key,
    this.mail
  }):super(key: key);

  @override
  State<MailEditingPage> createState() => _MailEditingPageState();
}

class _MailEditingPageState extends State<MailEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime dateAndTimeSend;
  late DateTime dateAndTimeReminder;
  final subjectController = TextEditingController();
  final contentController = TextEditingController();
  final toController = TextEditingController();
  final ccController = TextEditingController();
  final bccController = TextEditingController();
  var id;

  @override
  void initState(){
    super.initState();
    if(widget.mail == null){
      dateAndTimeSend = DateTime.now();
      dateAndTimeReminder = DateTime.now().add(Duration(days: 1));
      id = '1';
    }else{
      final mail = widget.mail!;
      subjectController.text = mail.subject;
      dateAndTimeReminder = mail.dateAndTimeReminder;
      dateAndTimeSend = mail.dateAndTimeSend;
      contentController.text = mail.content;
      toController.text = mail.to;
      ccController.text = mail.cc;
      bccController.text = mail.bcc;
      dateAndTimeReminder = mail.dateAndTimeReminder;
      dateAndTimeSend = mail.dateAndTimeSend;
      id = mail.id;
    }
  }

  @override
  void dispose(){
    super.dispose();
    subjectController.dispose();
    contentController.dispose();
    toController.dispose();
    ccController.dispose();
    bccController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: buildForm(),
          ),
      ),
    );
  }

   List<Widget> buildEditingActions() =>[
    ElevatedButton.icon( 
      onPressed: () {
        if(_formKey.currentState!.validate()){
        showModalBottomSheet(
  isScrollControlled: true,
  backgroundColor: Colors.transparent, // Make background transparent
  context: context,
  builder: (context) {
    return FractionallySizedBox(
      heightFactor: 0.8, // Adjust this value to control the height from the top
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Modal background color
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), // Rounded corners at the top
          ),
        ),
        child: widget.mail != null
            ? LoginMailWidget(
                mail: widget.mail,
                to: toController.text,
                cc: ccController.text,
                bcc: bccController.text,
                subject: subjectController.text,
                content: contentController.text,
                dateAndTimeSend: dateAndTimeSend,
                dateAndTimeReminder: dateAndTimeReminder,
                id: id,
              )
            : LoginMailWidget(
                to: toController.text,
                cc: ccController.text,
                bcc: bccController.text,
                subject: subjectController.text,
                content: contentController.text,
                dateAndTimeSend: dateAndTimeSend,
                dateAndTimeReminder: dateAndTimeReminder,
                id: id,
              ),
      ),
    );
  },
).then((_) => Navigator.of(context).pop());

        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent
      ),
      icon: Icon(Icons.check),
      label: Text("Save")    
    ),
  ];
  
  Widget buildForm() => ListView(
    children: [
      TextFormField(
        controller: toController,
        decoration: InputDecoration(labelText: 'To'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a recipient';
          }
          return null;
        },
      ),
      TextFormField(
        controller: ccController,
        decoration: InputDecoration(labelText: 'CC'),
      ),
      TextFormField(
        controller: bccController,
        decoration: InputDecoration(labelText: 'BCC'),
      ),
      TextFormField(
        controller: subjectController,
        decoration: InputDecoration(labelText: 'Subject'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a subject';
          }
          return null;
        },
      ),
      TextFormField(
        controller: contentController,
        decoration: InputDecoration(labelText: 'Content'),
        maxLines: 5,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter content for the email';
          }
          return null;
        },
      ),
      SizedBox(height: 24,),
      buildDateAndTimePickers()
    ],
  );
  
  
  
  Widget buildDateAndTimePickers() => Column(
    children: [
      buildSend(),
      buildReminder()
    ],
  );

  Widget buildSend() => buidlHeader(
    header:'SendAt',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: 
            buildDropDownField(
              text: Utils.toDate(dateAndTimeSend),
              onClicked: () =>pickSendDateTime(pickDate: true),
            )
        ),
        Expanded(
          child:
            buildDropDownField(
              text: Utils.toTime(dateAndTimeSend),
              onClicked: () => pickSendDateTime(pickDate: false),
            )
            
        )
      ],
      )
  );

  Widget buildReminder() => buidlHeader(
    header: 'ReminderAt', 
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child:
            buildDropDownField(
              text: Utils.toDate(dateAndTimeReminder),
              onClicked:() => pickReminderDateTime(pickDate: true),
            )
            
        ),
        Expanded(
          child:
            buildDropDownField(
              text: Utils.toTime(dateAndTimeReminder),
              onClicked: () => pickReminderDateTime(pickDate: false),
            )
            
        )
        
      ],
    )
    );




  
  buildDropDownField({required String text, required VoidCallback onClicked}) =>
  ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );
  
  buidlHeader({required String header, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: TextStyle(fontWeight: FontWeight.bold),),
      child
    ],
  );
  
  Future pickSendDateTime({required bool pickDate}) async{
    final date = await pickDateTime(dateAndTimeSend, pickDate:pickDate);
    if(date == null) return;

    if(date.isAfter(dateAndTimeReminder)){
      dateAndTimeReminder = DateTime(date.year, date.month, date.day);
    }
    setState(() {
      dateAndTimeSend = date; 
    });
  }
  
  
  Future<DateTime?> pickDateTime(DateTime initialDate, {required bool pickDate, DateTime? firstDate}) async{
    if (pickDate){
      final date = await showDatePicker(
        context: context, 
        initialDate: initialDate, 
        firstDate: firstDate ?? DateTime(2015,8),
        lastDate: DateTime(2101),
        );

      if(date == null) return null;
      
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute, seconds: initialDate.second);

      return date.add(time);

    }else{
      final timeOfDay = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(initialDate)
        );
       if(timeOfDay == null) return null;

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours:  timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
  
  Future pickReminderDateTime({required bool pickDate}) async{
    final date = await pickDateTime(dateAndTimeReminder, pickDate:pickDate, firstDate: pickDate? dateAndTimeSend: null);
    if (date == null) return;

    setState(() => dateAndTimeReminder = date);
  }
  
  
  
  
}