package com.example.authappkotlin

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.FirebaseException
import com.google.firebase.auth.*
import java.util.concurrent.TimeUnit

class PhoneAuthActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth
    private var verificationId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_phone)
        auth = FirebaseAuth.getInstance()

        val phoneEt = findViewById<android.widget.EditText>(R.id.phoneEt)
        val codeEt = findViewById<android.widget.EditText>(R.id.codeEt)
        val sendCodeBtn = findViewById<android.widget.Button>(R.id.sendCodeBtn)
        val verifyBtn = findViewById<android.widget.Button>(R.id.verifyBtn)

        sendCodeBtn.setOnClickListener {
            val phone = phoneEt.text.toString().trim()
            if (phone.isEmpty()) {
                android.widget.Toast.makeText(this, "Enter phone", android.widget.Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val options = PhoneAuthOptions.newBuilder(auth)
                .setPhoneNumber(phone)
                .setTimeout(60L, TimeUnit.SECONDS)
                .setActivity(this)
                .setCallbacks(object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
                    override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                        // Auto-retrieval or instant verification
                        auth.signInWithCredential(credential).addOnCompleteListener { task ->
                            if (task.isSuccessful) {
                                startActivity(android.content.Intent(this@PhoneAuthActivity, HomeActivity::class.java))
                                finish()
                            }
                        }
                    }

                    override fun onVerificationFailed(e: FirebaseException) {
                        android.widget.Toast.makeText(this@PhoneAuthActivity, "Verification failed: ${'$'}{e.message}", android.widget.Toast.LENGTH_LONG).show()
                    }

                    override fun onCodeSent(verificationId: String, token: PhoneAuthProvider.ForceResendingToken) {
                        super.onCodeSent(verificationId, token)
                        this@PhoneAuthActivity.verificationId = verificationId
                        android.widget.Toast.makeText(this@PhoneAuthActivity, "Code sent", android.widget.Toast.LENGTH_SHORT).show()
                    }
                }).build()
            PhoneAuthProvider.verifyPhoneNumber(options)
        }

        verifyBtn.setOnClickListener {
            val code = codeEt.text.toString().trim()
            val verId = verificationId
            if (verId == null) {
                android.widget.Toast.makeText(this, "Send code first", android.widget.Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val credential = PhoneAuthProvider.getCredential(verId, code)
            auth.signInWithCredential(credential).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    startActivity(android.content.Intent(this, HomeActivity::class.java))
                    finish()
                } else {
                    android.widget.Toast.makeText(this, "Verification failed: ${'$'}{task.exception?.message}", android.widget.Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}
