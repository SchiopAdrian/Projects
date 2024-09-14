import 'package:flutter/material.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/ui/task_editing_pange.dart';
import 'package:mobile_ui/utils/utils.dart';
import 'package:provider/provider.dart';


class TaskViewingPage extends StatelessWidget {
  final Task event;

  const TaskViewingPage({
    Key? key,
    required this.event,
  }):super(key: key);

  Widget buildDateTime(Task event){
    return Column(
      children: [
        buildDate('From', event.from),
        buildDate('To', event.to),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: CloseButton(),
      actions: buildViewingActions(context,event),
    ),
    body: ListView(
      padding: EdgeInsets.all(32),
      children: <Widget>[
        buildDateTime(event),
        SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            )
          ]
        ),
        const SizedBox(height: 24,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            )
          ]
        )
      ],
    ),
  );
  
  List<Widget> buildViewingActions(BuildContext context, Task event) => [
    IconButton(
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TaskEditingPage(event: event,)
          )
      ), 
      icon: Icon(Icons.edit)
      ),
      IconButton(
        onPressed: () {
          final provider = Provider.of<TaskProvider>(context, listen: false);
          provider.deleteEvent(event);
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
            Utils.toDate(date)
          )
        ),
        Expanded(
          flex: 2,
          child: Text(
            Utils.toTime(date)
          )
        )
      ],
      )
    
    );

  Widget buildHeader({
    required String header,
    required Widget child
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: TextStyle(fontWeight: FontWeight.bold),),
      child
    ],
  );
}