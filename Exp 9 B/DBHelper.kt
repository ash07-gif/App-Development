package com.example.todosqlite

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

data class Task(val id: Long, val title: String)

class DBHelper(context: Context): SQLiteOpenHelper(context, "tasks.db", null, 1) {
    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)")
    }
    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS tasks")
        onCreate(db)
    }
    fun insertTask(title: String): Long {
        val db = writableDatabase
        val cv = ContentValues()
        cv.put("title", title)
        return db.insert("tasks", null, cv)
    }
    fun getAllTasks(): MutableList<Task> {
        val list = mutableListOf<Task>()
        val cursor = readableDatabase.rawQuery("SELECT * FROM tasks ORDER BY id DESC", null)
        while (cursor.moveToNext()) {
            val id = cursor.getLong(cursor.getColumnIndexOrThrow("id"))
            val title = cursor.getString(cursor.getColumnIndexOrThrow("title"))
            list.add(Task(id, title))
        }
        cursor.close()
        return list
    }
    fun deleteTask(id: Long) {
        writableDatabase.delete("tasks", "id=?", arrayOf(id.toString()))
    }
}
