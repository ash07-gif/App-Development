package com.example.calculatorsqlite

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class HistoryActivity : AppCompatActivity() {

    private lateinit var db: DBHelper
    private lateinit var rv: RecyclerView
    private lateinit var adapter: HistoryAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_history)

        db = DBHelper(this)
        rv = findViewById(R.id.rvHistory)
        rv.layoutManager = LinearLayoutManager(this)

        loadData()
    }

    private fun loadData() {
        val items = db.getAllHistory()
        adapter = HistoryAdapter(items.toMutableList(), db) {
            // on delete callback - reload
            loadData()
        }
        rv.adapter = adapter
    }
}
