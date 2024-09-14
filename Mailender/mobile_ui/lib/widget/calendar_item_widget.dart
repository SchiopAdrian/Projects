import 'package:flutter/material.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:mobile_ui/model/calendar_data_source_extended.dart.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/ui/task_viewing_page.dart';
import 'package:mobile_ui/ui/mail_viewing_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CalendarItemWidget extends StatefulWidget {
  @override
  State<CalendarItemWidget> createState() => _CalendarItemWidgetState();
}


class _CalendarItemWidgetState extends State<CalendarItemWidget> {
  @override
  Widget build(BuildContext context) {
    final providerEvents = Provider.of<TaskProvider>(context);
    final providerMails = Provider.of<MailProvider>(context, listen: false);
    final selectedMails = providerMails.mailsOfSelectedDate;
    final selectedEvents = providerEvents.eventsOfSelectedDate;

    final allItems = [...providerMails.mails, ...providerEvents.events];
    if (selectedEvents.isEmpty && selectedMails.isEmpty) {
      return Center(
        child: Text(
          'No events found!',
          style: TextStyle(color: Colors.grey[700], fontSize: 24),
        ),
      );
    }

    Widget appointmentBuilder(
        BuildContext context, CalendarAppointmentDetails details) {
      final appointment = details.appointments.first;
      if (appointment is Task) {
        return Container(
          width: details.bounds.width,
          height: details.bounds.height,
          decoration: BoxDecoration(
            color: appointment.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              appointment.getTitle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        return Container(
          width: details.bounds.width,
          height: details.bounds.height,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              appointment.getTitle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.deepPurple[700],
        ),
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: CalendarDataSourceExtended(allItems),
        initialDisplayDate: providerEvents.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.deepPurpleAccent,
        selectionDecoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.3),
          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          if (details.appointments!.first is Mail){
            final mail = details.appointments!.first;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MailViewingPage(mail:mail)
              ));
          }else{
            final event = details.appointments!.first;

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TaskViewingPage(event: event)));
          }
        },
      ),
    );
  }
}