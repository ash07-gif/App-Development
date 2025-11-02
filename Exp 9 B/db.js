import SQLite from 'react-native-sqlite-storage';

SQLite.DEBUG(true);
SQLite.enablePromise(true);

const database_name = "TodoDB.db";
const database_version = "1.0";
const database_displayname = "SQLite Todo Database";
const database_size = 200000;

let db;

const DB = {
  init: async () => {
    try {
      db = await SQLite.openDatabase({name: database_name, location: 'default'});
      await db.executeSql(
        `CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          done INTEGER DEFAULT 0,
          created_at DATETIME DEFAULT (datetime('now','localtime'))
        );`
      );
    } catch (err) {
      console.log('DB init error', err);
    }
  },
  close: async () => {
    if (db) {
      try {
        await db.close();
        console.log('DB CLOSED');
      } catch (err) {
        console.log('DB close error', err);
      }
    }
  },
  addTask: async (title) => {
    const res = await db.executeSql('INSERT INTO tasks (title, done) VALUES (?,0);', [title]);
    return res;
  },
  getAllTasks: async () => {
    const [results] = await db.executeSql('SELECT * FROM tasks ORDER BY id DESC;');
    const rows = results.rows;
    const out = [];
    for (let i = 0; i < rows.length; i++) {
      out.push(rows.item(i));
    }
    return out;
  },
  updateTaskDone: async (id, done) => {
    await db.executeSql('UPDATE tasks SET done=? WHERE id=?;', [done, id]);
  },
  deleteTask: async (id) => {
    await db.executeSql('DELETE FROM tasks WHERE id=?;', [id]);
  },
  clearCompleted: async () => {
    await db.executeSql('DELETE FROM tasks WHERE done=1;');
  }
};

export default DB;