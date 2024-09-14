import 'package:mobile_ui/database/database_helper.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/services/mail_service.dart';

class MailRepository {
  final DatabaseHelper _databaseHelper;
  final MailService _mailService;

  MailRepository(this._databaseHelper, this._mailService);

  // Fetch all mails from the local database
  Future<List<Mail>> fetchLocalMails() async {
    return await _databaseHelper.mails();
  }

  // Add a new mail to the local database
  Future<void> addMail(Mail mail) async {
    await _databaseHelper.insertMail(mail);
  }

  // Mark a mail as deleted in the local database
  Future<void> markMailAsDeleted(String mailId) async {
    await _databaseHelper.markMailAsDeleted(mailId);
  }

  // Mark a mail as updated in the local database
  Future<void> markMailAsUpdated(String mailId) async {
    await _databaseHelper.markMailAsUpdated(mailId);
  }

  // Update a mail in the local database
  Future<void> updateMail(Mail mail) async {
    await _databaseHelper.updateMail(mail);
  }

  // Delete a mail from the local database
  Future<void> deleteMail(String mailId) async {
    await _databaseHelper.deleteMail(mailId);
  }

  // Synchronize local mail data with the server
  Future<void> syncMails() async {
    final unsyncedMails = await _databaseHelper.getUnsyncedMails();
    final deletedMails = await _databaseHelper.getDeletedMails();
    final updatedMails = await _databaseHelper.getUpdatedMails();

    // Sync unsynced mails to the server
    for (final mail in unsyncedMails) {
      try {
        await _mailService.createMail(mail);
        await _databaseHelper.markMailsAsSynced(mail.id);
      } catch (e) {
        print('Error syncing mail ${mail.id}: $e');
      }
    }

    // Sync updated mails to the server
    for (final mail in updatedMails) {
      try {
        await _mailService.updateMail(mail.id, mail);
        await _databaseHelper.markMailsAsSynced(mail.id);
      } catch (e) {
        print('Error updating mail ${mail.id}: $e');
      }
    }

    // Sync deleted mails to the server
    for (final mail in deletedMails) {
      try {
        await _mailService.deleteMail(mail.id);
        await _databaseHelper.deleteMail(mail.id);
      } catch (e) {
        print('Error deleting mail ${mail.id}: $e');
      }
    }
  }

  // Check if the server is reachable
  Future<bool> isServerReachable() async {
    return await _mailService.checkServerHealth();
  }

  // Fetch mails from the remote server
  Future<List<Mail>> fetchRemoteMails() async {
    return await _mailService.fetchMails();
  }
}
