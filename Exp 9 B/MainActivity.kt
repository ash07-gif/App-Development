package com.example.todosqlite

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class MainActivity : AppCompatActivity() {

    private lateinit var db: DBHelper
    private lateinit var adapter: TaskAdapter
    private lateinit var rv: RecyclerView
    private lateinit var etTask: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        db = DBHelper(this)
        etTask = findViewById(R.id.etTask)
        rv = findViewById(R.id.rvTasks)
        rv.layoutManager = LinearLayoutManager(this)

        loadTasks()

        val btnAdd: Button = findViewById(R.id.btnAdd)
        btnAdd.setOnClickListener {
            val title = etTask.text.toString().trim()
            if (title.isNotEmpty()) {
                db.insertTask(title)
                etTask.text.clear()
                loadTasks()
            }
        }
    }

    private fun loadTasks() {
        val tasks = db.getAllTasks()
        adapter = TaskAdapter(tasks, db) { loadTasks() }
        rv.adapter = adapter
    }
}
