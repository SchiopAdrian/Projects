import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/database/database_helper.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/repository/mail_repository.dart';

class MailProvider extends ChangeNotifier {
  final MailRepository _mailRepository;
  final List<Mail> _mails = [];
  DateTime _selectedDate = DateTime.now();
  late String _userEmail;
  late String _userPassword;
  bool _isSyncing = false;

  MailProvider(this._mailRepository) {
    _loadMails();
  }

  List<Mail> get mails => _mails;

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
  }

  List<Mail> get mailsOfSelectedDate => _mails;

  String get userEmail => _userEmail;

  String get userPassword => _userPassword;
  

  Future<void> _loadMails() async {
    _mails.clear();
    final mailList = await _mailRepository.fetchLocalMails(); // Load from DB
    _mails.addAll(mailList);
    notifyListeners();
  }
  Future<void> fetchMailsAfterLogin() async {
    await _loadMails();
  }

  Future<void> addMail(Mail mail) async {
    await _mailRepository.addMail(mail);
    _mails.add(mail);
    notifyListeners();
    _syncWithServer();
  }

  Future<void> deleteMail(Mail mail) async {
    await _mailRepository.markMailAsDeleted(mail.id); // Mark as deleted in DB
    _mails.removeWhere((element) => element.id == mail.id);
    notifyListeners();
    _syncWithServer();
  }

  Future<void> editMail(Mail newMail, Mail oldMail) async {
    await _mailRepository.markMailAsUpdated(newMail.id);
    await _mailRepository.updateMail(newMail); // Update in DB
    final index = _mails.indexWhere((mail) => mail.id == oldMail.id);
    if (index != -1) {
      _mails[index] = newMail;
      notifyListeners();
      _syncWithServer();
    }
  }

  Future<void> _syncWithServer() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection. Sync deferred.');
      return;
    }

    _isSyncing = true;
    notifyListeners();

    try {
      if (await _mailRepository.isServerReachable()) {
        await _mailRepository.syncMails();
        await _loadMails();
      } else {
        print('Server is not reachable. Sync deferred.');
      }
    } catch (e) {
      print('Error during sync: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
