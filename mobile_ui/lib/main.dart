import 'package:flutter/material.dart';
import 'package:mobile_ui/database/database_helper.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/provider/user_provider.dart';
import 'package:mobile_ui/repository/task_repository.dart';
import 'package:mobile_ui/repository/mail_repository.dart';
import 'package:mobile_ui/services/auth_service.dart';
import 'package:mobile_ui/services/task_service.dart';
import 'package:mobile_ui/services/mail_service.dart';
import 'package:mobile_ui/ui/main_page.dart';
import 'package:mobile_ui/ui/sign_in_page.dart';
import 'package:mobile_ui/ui/sign_up_page.dart';
import 'package:provider/provider.dart';

void main() async{
  // Initialize services and repositories

  final TaskService eventService = TaskService(); 
  final DatabaseHelper databaseHelper = DatabaseHelper();// Assume EventService is implemented\
  final MailService mailService = MailService();
  final MailRepository mailRepository = MailRepository(databaseHelper, mailService);
  final TaskRepository eventRepository = TaskRepository(databaseHelper,eventService); // Create EventRepository with EventService
  final AuthService authService = AuthService();
  runApp( 
    MyApp(eventRepository: eventRepository,authService: authService, mailRepository:mailRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository eventRepository; // EventRepository instance
  final AuthService authService;
  final MailRepository mailRepository;
  const MyApp({super.key, required this.eventRepository, required this.authService, required this.mailRepository});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
    MultiProvider( 
      providers: [ChangeNotifierProvider(create: (context) =>TaskProvider(eventRepository),),
                  ChangeNotifierProvider(create: (context) =>MailProvider(mailRepository),),
                  ChangeNotifierProvider(create: (context) =>UserProvider(authService))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mailender",
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
          appBarTheme: AppBarTheme(backgroundColor: const Color.fromARGB(255, 85, 16, 12))
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SignInPage(),
          '/sign_up': (context) =>SignUpPage(),
          '/home': (context) => MainPage(),
        },
      )
    );
  
}


