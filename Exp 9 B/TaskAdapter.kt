package com.example.todosqlite

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class TaskAdapter(private val tasks: MutableList<Task>, private val db: DBHelper, private val onDelete: () -> Unit)
    : RecyclerView.Adapter<TaskAdapter.VH>() {

    inner class VH(v: View): RecyclerView.ViewHolder(v) {
        val tvTask: TextView = v.findViewById(R.id.tvTask)
        val btnDelete: Button = v.findViewById(R.id.btnDelete)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        return VH(LayoutInflater.from(parent.context).inflate(R.layout.item_task, parent, false))
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        val t = tasks[position]
        holder.tvTask.text = t.title
        holder.btnDelete.setOnClickListener {
            db.deleteTask(t.id)
            tasks.removeAt(position)
            notifyItemRemoved(position)
            onDelete()
        }
    }

    override fun getItemCount() = tasks.size
}
