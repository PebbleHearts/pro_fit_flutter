import 'package:googleapis/drive/v3.dart';
import 'package:pro_fit_flutter/constants/google.dart';

class DataBackupService {
  Future<String?> _checkIfFolderExists(String folderName) async {
    final FileList? folders = await signInHelper.driveApi?.files.list(
        q: "name='$folderName' and trashed=false and mimeType='application/vnd.google-apps.folder'");
    print(folders?.files?.first);
    if (folders != null && folders.files!.isNotEmpty) {
      final folderId = folders.files?.first.id;
      return folderId;
    }
    return null;
  }

  void _checkIfFileExists(String folderId) async {
    final FileList? data = await signInHelper.driveApi?.files.list(
        q: "'$folderId' in parents and name='profit.json' and trashed = false");
    if (data != null) {
      print(data.files?.last.name);
    }
  }

  void upload() async {
    String? folderId = await _checkIfFolderExists('profit-backup');
    if (folderId != null) {
      _checkIfFileExists(folderId);
    }
  }
}
