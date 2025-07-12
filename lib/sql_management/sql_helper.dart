import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class SqlHelper {
  static Database ?database;

  static getDatabase () async {
    if (database==null){
      database= await initdatabase();
      return database ;
    }
    else{
      return database ;
    }
  }

  // الفانكشن دي بتشتغل مره واحده بس في اول مره
  static initdatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.dp');
    return await openDatabase(path, version: 1, onCreate: (dp, index) async {
      Batch batch = dp.batch();
      batch.execute('''
         CREATE TABLE tasks(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           title TEXT,
           desc TEXT,
           day TEXT,
           time TEXT,
           isCompleted INTEGER
         )
         ''');
      batch.commit();
    });
  }

  //CRUD Operation

  //create
  Future addTask(Task newTask) async {
    Database db = await getDatabase();

    await db.insert(
      'tasks',
      newTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  //read
  Future<List<Map>> loadTasks() async {
    Database db = await getDatabase();
    return await db.query('tasks');
  }

  //update
  Future updateTask(Task task) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    batch.commit();
  }

  //delete
  Future deleteTask(int id) async {
    Database db = await getDatabase();
    await db.delete(
        'tasks',
        where: 'id=?',
        whereArgs: [id]
    );
  }

  //separation
  Future<void> updateIsCompleted(int id, int isCompleted) async {
    Database db = await getDatabase();
    await db.update(
      'tasks',
      {'isCompleted': isCompleted},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  //search
  Future<List<Map<String, dynamic>>> search(String title) async {
    Database db = await getDatabase();
    return await db.query(
      'tasks',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
