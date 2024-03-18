import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:drift/drift.dart' as drift;
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/constants/google.dart';
import 'package:pro_fit_flutter/database/database.dart';

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

  Future<List<Map<String, dynamic>>> _getFormattedCategoriesData() async {
    List<CategoryData> allCategoryItems =
        await database.categoryDao.getAllCategoriesIncludeDeleted();
    return allCategoryItems.map((e) => e.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _getFormattedExercisesData() async {
    List<ExerciseData> allExerciseItems =
        await database.exerciseDao.getAllExercisesIncludeDeleted();
    return allExerciseItems.map((e) => e.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _getFormattedExerciseLogsData() async {
    List<ExerciseLogData> allExerciseLogItems =
        await database.exerciseLogDao.getAllExercisesLog();
    return allExerciseLogItems.map((e) => e.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _getFormattedRoutinesData() async {
    List<RoutineData> allRoutinesItems =
        await database.routineDao.getAllRoutines();
    return allRoutinesItems.map((e) => e.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>>
      _getFormattedRoutineDetailItemsData() async {
    List<RoutineDetailItemData> allRoutineDetailItems =
        await database.routineDetailItemDao.getAllRoutineDetailItems();
    return allRoutineDetailItems.map((e) => e.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getBackupJsonData() async {
    final categoryData = await _getFormattedCategoriesData();
    final exercisesData = await _getFormattedExercisesData();
    final exerciseLogsData = await _getFormattedExerciseLogsData();
    final routineData = await _getFormattedRoutinesData();
    final routineDetailItemsData = await _getFormattedRoutineDetailItemsData();
    final Map<String, dynamic> jsonContent = {
      'category': categoryData,
      'exercise': exercisesData,
      'exerciseLogs': exerciseLogsData,
      'routine': routineData,
      'routineDetailItems': routineDetailItemsData,
    };
    return jsonContent;
  }

  Future<void> upload() async {
    String? fileId;
    String? folderId = await _getFolderId('profit-backup-flutter');
    if (folderId != null) {
      fileId = await _getFileId(folderId, 'profit.json');
    }
    if (fileId != null) {
      print(fileId);

      final jsonContent = await _getBackupJsonData();
      final media = drive.Media(
          Stream.value(utf8.encode(json.encode(jsonContent))),
          json.encode(jsonContent).length,
          contentType: 'application/json');

      final fileItem = await signInHelper.driveApi?.files
          .update(drive.File(), fileId, uploadMedia: media);
    }
  }

  Future<void> _initializeCategoryData(List<dynamic> categoryTableJson) async {
    for (var i = 0; i < categoryTableJson.length; i++) {
      final data = CategoryData.fromJson(categoryTableJson[i]);
      database.categoryDao.insertCategoryRow(
        CategoryCompanion(
          id: drift.Value(data.id),
          name: drift.Value(data.name),
          status: drift.Value(data.status),
        ),
      );
    }
  }

  Future<void> _initializeExerciseData(List<dynamic> exerciseTableJson) async {
    for (var i = 0; i < exerciseTableJson.length; i++) {
      final data = ExerciseData.fromJson(exerciseTableJson[i]);
      database.exerciseDao.insertExerciseRow(
        ExerciseCompanion(
          id: drift.Value(data.id),
          name: drift.Value(data.name),
          categoryId: drift.Value(data.categoryId),
          status: drift.Value(data.status),
        ),
      );
    }
  }

  Future<void> _initializeExerciseLogData(
      List<dynamic> exerciseLogTableJson) async {
    for (var i = 0; i < exerciseLogTableJson.length; i++) {
      final data = ExerciseLogData.fromJson(exerciseLogTableJson[i]);
      database.exerciseLogDao.insertExerciseLogRow(
        ExerciseLogCompanion(
          id: drift.Value(data.id),
          exerciseId: drift.Value(data.exerciseId),
          workoutRecords: drift.Value(data.workoutRecords),
          description: drift.Value(data.description),
          logDate: drift.Value(data.logDate),
          order: drift.Value(data.order),
        ),
      );
    }
  }

  Future<void> _initializeRoutineData(List<dynamic> routineTableJson) async {
    for (var i = 0; i < routineTableJson.length; i++) {
      final data = RoutineData.fromJson(routineTableJson[i]);
      database.routineDao.insertRoutineRow(
        RoutineCompanion(
          id: drift.Value(data.id),
          name: drift.Value(data.name),
        ),
      );
    }
  }

  Future<void> _initializeRoutineDetailItemData(
      List<dynamic> routineDetailItemsTableJson) async {
    for (var i = 0; i < routineDetailItemsTableJson.length; i++) {
      final data = RoutineDetailItemData.fromJson(routineDetailItemsTableJson[i]);
      database.routineDetailItemDao.insertRoutineDetailItemRow(
        RoutineDetailItemCompanion(
          id: drift.Value(data.id),
          exerciseId: drift.Value(data.exerciseId),
          routineId: drift.Value(data.routineId),
        ),
      );
    }
  }

  Future<void> import() async {
    String? fileId;
    String? folderId = await _getFolderId('profit-backup-flutter');
    if (folderId != null) {
      fileId = await _getFileId(folderId, 'profit.json');
    }
    if (fileId != null) {
      final drive.Media media = await signInHelper.driveApi?.files.get(fileId,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
      String fullText = await utf8.decodeStream((media.stream));
      Map<String, dynamic> jsonMap = json.decode(fullText);
      await _initializeCategoryData(jsonMap['category']);
      await _initializeExerciseData(jsonMap['exercise']);
      // await _initializeExerciseLogData(jsonMap['exerciseLogs']);
      await _initializeRoutineData(jsonMap['routine']);
      await _initializeRoutineDetailItemData(jsonMap['routineDetailItems']);
    }
  }
}
