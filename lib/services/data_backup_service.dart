import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pro_fit_flutter/constants/google.dart';

class DataBackupService {
  Future<String?> _createFolder(String folderName) async {
    final folder = drive.File(
      name: folderName,
      mimeType: 'application/vnd.google-apps.folder',
    );
    final drive.File? createdFolder =
        await signInHelper.driveApi?.files.create(folder);

    if (createdFolder != null) {
      return createdFolder.id;
    }
    return null;
  }

  Future<String?> _createFile(String fileName, String folderId) async {
    final file = drive.File(
      name: fileName,
      parents: [folderId],
    );
    final drive.File? createdFile =
        await signInHelper.driveApi?.files.create(file);

    if (createdFile != null) {
      print(createdFile);
      return createdFile.id;
    }
    return null;
  }

  Future<String?> _getFolderId(String folderName) async {
    String? folderId;
    final drive.FileList? folders = await signInHelper.driveApi?.files.list(
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
    final drive.FileList? data = await signInHelper.driveApi?.files.list(
        q: "'$folderId' in parents and name='profit.json' and trashed=false");
    if (data != null && data.files != null && data.files!.isNotEmpty) {
      fileId = data.files?.first.id;
    } else {
      fileId = await _createFile(fileName, folderId);
    }
    return fileId;
  }

  Map<String, dynamic> _getBackupJsonData() {
    final Map<String, dynamic> jsonContent = {
      'key1': 'value1',
      'key2': 'value 2',
    };
    return jsonContent;
  }

  void upload() async {
    String? fileId;
    String? folderId = await _getFolderId('profit-backup-flutter');
    if (folderId != null) {
      fileId = await _getFileId(folderId, 'profit.json');
    }
    if (fileId != null) {
      print(fileId);

      final jsonContent = _getBackupJsonData();
      final media = drive.Media(
          Stream.value(utf8.encode(json.encode(jsonContent))),
          json.encode(jsonContent).length,
          contentType: 'application/json');

      final fileItem = await signInHelper.driveApi?.files
          .update(drive.File(), fileId, uploadMedia: media);
    }
  }
}
