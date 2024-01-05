import 'package:googleapis/drive/v3.dart';
import 'package:pro_fit_flutter/constants/google.dart';

class DataBackupService {
  Future<String?> _createFolder(String folderName) async {
    final folder = File(
      name: folderName,
      mimeType: 'application/vnd.google-apps.folder',
    );
    final File? createdFolder =
        await signInHelper.driveApi?.files.create(folder);

    if (createdFolder != null) {
      return createdFolder.id;
    }
    return null;
  }

  Future<String?> _createFile(String fileName, String folderId) async {
    final file = File(
      name: fileName,
      parents: [folderId],
    );
    final File? createdFile =
        await signInHelper.driveApi?.files.create(file);

    if (createdFile != null) {
      print(createdFile);
      return createdFile.id;
    }
    return null;
  }

  Future<String?> _getFolderId(String folderName) async {
    String? folderId;
    final FileList? folders = await signInHelper.driveApi?.files.list(
        q: "name='$folderName' and trashed=false and mimeType='application/vnd.google-apps.folder'");
    if (folders != null && folders.files!.isNotEmpty) {
      folderId = folders.files?.first.id;
    } else {
      folderId = await _createFolder(folderName);
    }
    return folderId;
  }

  Future<String?> _getFileId(String folderId, String fileName) async {
    String? fileId;
    final FileList? data = await signInHelper.driveApi?.files.list(
        q: "'$folderId' in parents and name='profit.json' and trashed=false");
    if (data != null && data.files != null && data.files!.isNotEmpty) {
      fileId = data.files?.first.id;
    } else {
      fileId = await _createFile(fileName, folderId);
    }
    return fileId;
  }

  void upload() async {
    String? fileId;
    String? folderId = await _getFolderId('profit-backup-flutter');
    if (folderId != null) {
      fileId = await _getFileId(folderId, 'profit.json');
    }
    if (fileId != null) {
      print(fileId);
    }
  }
}
