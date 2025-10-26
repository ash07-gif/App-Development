package com.example.calculatorsqlite

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

data class HistoryItem(val id: Long, val expression: String, val result: String, val timestamp: String)

class DBHelper(context: Context): SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {
    companion object {
        private const val DATABASE_NAME = "calculator.db"
        private const val DATABASE_VERSION = 1
        private const val TABLE_HISTORY = "history"
        private const val COL_ID = "id"
        private const val COL_EXPR = "expression"
        private const val COL_RESULT = "result"
        private const val COL_TS = "timestamp"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val create = "CREATE TABLE ${TABLE_HISTORY} (" +
                "$COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "$COL_EXPR TEXT, " +
                "$COL_RESULT TEXT, " +
                "$COL_TS TEXT)"
        db.execSQL(create)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS ${TABLE_HISTORY}")
        onCreate(db)
    }

    fun insertHistory(expression: String, result: String, timestamp: String): Long {
        val db = writableDatabase
        val cv = ContentValues()
        cv.put(COL_EXPR, expression)
        cv.put(COL_RESULT, result)
        cv.put(COL_TS, timestamp)
        return db.insert(TABLE_HISTORY, null, cv)
    }

    fun deleteHistory(id: Long) {
        val db = writableDatabase
        db.delete(TABLE_HISTORY, "$COL_ID = ?", arrayOf(id.toString()))
    }

    fun getAllHistory(): List<HistoryItem> {
        val list = mutableListOf<HistoryItem>()
        val db = readableDatabase
        val cursor = db.query(TABLE_HISTORY, null, null, null, null, null, "$COL_ID DESC")
        while (cursor.moveToNext()) {
            val id = cursor.getLong(cursor.getColumnIndexOrThrow(COL_ID))
            val expr = cursor.getString(cursor.getColumnIndexOrThrow(COL_EXPR))
            val res = cursor.getString(cursor.getColumnIndexOrThrow(COL_RESULT))
            val ts = cursor.getString(cursor.getColumnIndexOrThrow(COL_TS))
            list.add(HistoryItem(id, expr, res, ts))
        }
        cursor.close()
        return list
    }
}
