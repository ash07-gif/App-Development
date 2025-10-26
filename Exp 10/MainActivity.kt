package com.example.calculatorfirebase

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import javax.script.ScriptEngineManager

class MainActivity : AppCompatActivity() {

    private lateinit var inputExpression: EditText
    private lateinit var btnCalculate: Button
    private lateinit var tvResult: TextView
    private lateinit var historyLayout: LinearLayout
    private val db = FirebaseFirestore.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        inputExpression = findViewById(R.id.inputExpression)
        btnCalculate = findViewById(R.id.btnCalculate)
        tvResult = findViewById(R.id.tvResult)
        historyLayout = findViewById(R.id.historyLayout)

        btnCalculate.setOnClickListener {
            calculateAndSave()
        }

        loadHistory()
    }

    private fun calculateAndSave() {
        val expression = inputExpression.text.toString()
        if (expression.isNotEmpty()) {
            try {
                val engine = ScriptEngineManager().getEngineByName("rhino")
                val result = engine.eval(expression).toString()
                tvResult.text = "Result: $result"

                val data = hashMapOf(
                    "expression" to expression,
                    "result" to result,
                    "timestamp" to System.currentTimeMillis()
                )

                db.collection("calculations").add(data)
                    .addOnSuccessListener {
                        Toast.makeText(this, "Saved to Firestore", Toast.LENGTH_SHORT).show()
                        inputExpression.text.clear()
                    }
                    .addOnFailureListener {
                        Toast.makeText(this, "Failed: ${it.message}", Toast.LENGTH_SHORT).show()
                    }

            } catch (e: Exception) {
                tvResult.text = "Error"
            }
        }
    }

    private fun loadHistory() {
        db.collection("calculations")
            .orderBy("timestamp")
            .addSnapshotListener { snapshots, e ->
                if (e != null || snapshots == null) return@addSnapshotListener
                historyLayout.removeAllViews()
                for (doc in snapshots) {
                    val textView = TextView(this)
                    textView.text = "${doc.getString("expression")} = ${doc.getString("result")}"
                    historyLayout.addView(textView)
                }
            }
    }
}
