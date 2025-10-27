package com.example.todolist

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.firestore.FirebaseFirestore

class MainActivity : AppCompatActivity() {

    private lateinit var db: FirebaseFirestore
    private lateinit var taskAdapter: TaskAdapter
    private val taskList = mutableListOf<Task>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        db = FirebaseFirestore.getInstance()

        val taskInput: EditText = findViewById(R.id.taskInput)
        val addButton: Button = findViewById(R.id.addButton)
        val recycler: RecyclerView = findViewById(R.id.taskRecycler)

        recycler.layoutManager = LinearLayoutManager(this)
        taskAdapter = TaskAdapter(taskList) { task -> deleteTask(task) }
        recycler.adapter = taskAdapter

        addButton.setOnClickListener {
            val text = taskInput.text.toString().trim()
            if (text.isNotEmpty()) {
                addTask(text)
                taskInput.text.clear()
            }
        }

        loadTasks()
    }

    private fun addTask(text: String) {
        val task = hashMapOf("text" to text)
        db.collection("tasks").add(task)
    }

    private fun loadTasks() {
        db.collection("tasks").addSnapshotListener { snapshot, e ->
            if (snapshot != null) {
                taskList.clear()
                for (doc in snapshot.documents) {
                    val task = Task(doc.id, doc.getString("text"))
                    taskList.add(task)
                }
                taskAdapter.notifyDataSetChanged()
            }
        }
    }

    private fun deleteTask(task: Task) {
        task.id?.let { db.collection("tasks").document(it).delete() }
    }
}
