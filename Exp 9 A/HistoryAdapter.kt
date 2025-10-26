package com.example.calculatorsqlite

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class HistoryAdapter(private val items: MutableList<HistoryItem>, private val db: DBHelper, private val onDeleted: () -> Unit)
    : RecyclerView.Adapter<HistoryAdapter.VH>() {

    class VH(view: View): RecyclerView.ViewHolder(view) {
        val tvExpr: TextView = view.findViewById(R.id.tvExpression)
        val tvRes: TextView = view.findViewById(R.id.tvResultItem)
        val tvTs: TextView = view.findViewById(R.id.tvTimestamp)
        val btnDelete: Button = view.findViewById(R.id.btnDelete)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_history, parent, false)
        return VH(v)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        val item = items[position]
        holder.tvExpr.text = item.expression
        holder.tvRes.text = "Result: " + item.result
        holder.tvTs.text = item.timestamp
        holder.btnDelete.setOnClickListener {
            db.deleteHistory(item.id)
            items.removeAt(position)
            notifyItemRemoved(position)
            onDeleted()
        }
    }

    override fun getItemCount(): Int = items.size
}
