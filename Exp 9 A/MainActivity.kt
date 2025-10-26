package com.example.calculatorsqlite

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : AppCompatActivity() {

    private lateinit var etOperand1: EditText
    private lateinit var etOperand2: EditText
    private lateinit var tvResult: TextView
    private var operator: String = "+"

    private lateinit var db: DBHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etOperand1 = findViewById(R.id.etOperand1)
        etOperand2 = findViewById(R.id.etOperand2)
        tvResult = findViewById(R.id.tvResult)

        val btnAdd: Button = findViewById(R.id.btnAdd)
        val btnSub: Button = findViewById(R.id.btnSub)
        val btnMul: Button = findViewById(R.id.btnMul)
        val btnDiv: Button = findViewById(R.id.btnDiv)
        val btnEqual: Button = findViewById(R.id.btnEqual)
        val btnHistory: Button = findViewById(R.id.btnHistory)

        db = DBHelper(this)

        btnAdd.setOnClickListener { operator = "+"; tvResult.text = "Result: (operator +)"}
        btnSub.setOnClickListener { operator = "-"; tvResult.text = "Result: (operator -)"}
        btnMul.setOnClickListener { operator = "*"; tvResult.text = "Result: (operator ×)"}
        btnDiv.setOnClickListener { operator = "/"; tvResult.text = "Result: (operator ÷)"}

        btnEqual.setOnClickListener {
            val aText = etOperand1.text.toString().trim()
            val bText = etOperand2.text.toString().trim()
            if (aText.isEmpty() || bText.isEmpty()) {
                tvResult.text = "Result: enter both operands"
                return@setOnClickListener
            }
            val a = aText.toDoubleOrNull()
            val b = bText.toDoubleOrNull()
            if (a == null || b == null) {
                tvResult.text = "Result: invalid number"
                return@setOnClickListener
            }
            val res = when(operator) {
                "+" -> a + b
                "-" -> a - b
                "*" -> a * b
                "/" -> if (b == 0.0) Double.NaN else a / b
                else -> 0.0
            }
            val expr = "$a $operator $b"
            val resStr = if (res.isNaN()) "NaN" else res.toString()
            tvResult.text = "Result: $resStr"

            // insert into DB
            val ts = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(Date())
            db.insertHistory(expr, resStr, ts)
        }

        btnHistory.setOnClickListener {
            startActivity(Intent(this, HistoryActivity::class.java))
        }
    }
}
