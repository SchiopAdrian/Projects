import 'package:flutter/material.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/provider/user_provider.dart';
import 'package:mobile_ui/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class TaskEditingPage extends StatefulWidget {
  

  final Task? event;

  const TaskEditingPage({
    Key? key,
    this.event
  }): super(key: key);

  @override
  State<TaskEditingPage> createState() => _TaskEditingPageState();
}

class _TaskEditingPageState extends State<TaskEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  void initState(){
    super.initState();
    if(widget.event == null){
    fromDate = DateTime.now();
    toDate = DateTime.now().add(Duration(hours: 2));
    }else{
      final event = widget.event!;
      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose(){
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions:  buildEditingActions()
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              SizedBox(height: 12,),
              buildDateTimePickers(),
              SizedBox(height: 12,),
              buildDetails()
            ],
          )
        )
      ),
    );
   
  }
  List<Widget> buildEditingActions() =>[
    ElevatedButton.icon( 
      onPressed: saveForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent
      ),
      icon: Icon(Icons.check),
      label: Text("Save")    
    ),
  ];
  
  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Title",
    ),
    onFieldSubmitted: (_) => saveForm(),
    validator: (title) =>
        title != null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );


  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );
  
  Widget buildFrom() => buildHeader(
    header: 'FROM',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child:
            buildDropDownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            )
            
        ),
        Expanded(
          child:
            buildDropDownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            )
            
        )
        
      ],
    )
  );

  Widget buildTo() => buildHeader(
    header: 'To',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child:
            buildDropDownField(
              text: Utils.toDate(toDate),
              onClicked:() => pickToDateTime(pickDate: true),
            )
            
        ),
        Expanded(
          child:
            buildDropDownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            )
            
        )
        
      ],
    )
  );
    
  Widget  buildDropDownField({required String text, required VoidCallback onClicked }) => ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
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
  
  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(toDate, pickDate:pickDate, firstDate: pickDate? fromDate: null);
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate, pickDate:pickDate);
    if (date == null) return;

    if(date.isAfter(toDate)){
      toDate = DateTime(date.year,date.month,date.day);
    }

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate,{
    required bool pickDate,
    DateTime? firstDate
  }) async{
    if(pickDate){
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015,8),
        lastDate: DateTime(2101),
        );
      if(date == null) return null;

      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

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

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid){
      final authProvider = Provider.of<UserProvider>(context, listen: false);
      final idUser = authProvider.userId;
      var id = Uuid();
      
      
      final isEditing = widget.event != null;
      final provider = Provider.of<TaskProvider>(context, listen: false);
      if(isEditing){
        final event = Task(
        id:widget.event!.id,
        title: titleController.text,  
        from: fromDate, 
        to: toDate,
        description: descriptionController.text,
        idUser: idUser!,
        isSynced: true,
        );
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      }else{
        final event = Task(
        id:id.v4(),
        title: titleController.text,  
        from: fromDate, 
        to: toDate,
        description: descriptionController.text,
        idUser: idUser!,
        );
        provider.addEvenet(event);
        Navigator.of(context).pop();
      }
      
    }
  }
  
  Widget buildDetails() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Description",
    ),
    maxLines: 5,
    onFieldSubmitted: (_) => saveForm(),
    validator: (description) =>
        description != null && description.isEmpty ? 'Title cannot be empty' : null,
    controller: descriptionController,
  );
}

