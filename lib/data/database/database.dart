import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:io';
import 'package:path/path.dart' as p;

import '../../domain/entities/category.dart';
import '../../domain/entities/task.dart';

part 'database.g.dart';

class Categories extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get categoryId => text().customConstraint('REFERENCES categories(id)')();
  TextColumn get photoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


@DriftDatabase(tables: [Categories, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<void> insertCategory(Category category) => into(categories).insert(category);
  Future<void> deleteCategory(String id) => (delete(categories)..where((c) => c.id.equals(id))).go();
  Future<void> updateCategory(Category category) => update(categories).replace(category);


  Future<List<Task>> getTasksByCategory(String categoryId) => (select(tasks)..where((t) => t.categoryId.equals(categoryId))).get();
  Future<void> insertTask(Task task) => into(tasks).insert(task);
  Future<void> deleteTask(String id) => (delete(tasks)..where((t) => t.id.equals(id))).go();
  Future<void> updateTask(Task task) => update(tasks).replace(task);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
