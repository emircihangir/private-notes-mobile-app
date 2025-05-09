package com.example.privatenotes

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import android.view.WindowManager
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.save_to_downloads"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloads" -> {
                    val content = call.argument<String>("content")
                    val fileName = call.argument<String>("fileName")
                    val mimeType = call.argument<String>("mimeType")
                    
                    if (content == null || fileName == null || mimeType == null) {
                        result.error("INVALID_ARGUMENTS", "Content, fileName, and mimeType must be provided", null)
                        return@setMethodCallHandler
                    }
                    
                    val saved = saveToDownloads(content, fileName, mimeType)
                    result.success(saved)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun saveToDownloads(content: String, fileName: String, mimeType: String): Boolean {
        // For Android 10 (API 29) and above, we use MediaStore
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(MediaStore.MediaColumns.RELATIVE_PATH, "Download")
            }
            
            val resolver = contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
            
            return if (uri != null) {
                try {
                    resolver.openOutputStream(uri)?.use { outputStream ->
                        outputStream.write(content.toByteArray())
                    }
                    true
                } catch (e: IOException) {
                    e.printStackTrace()
                    // If there was an error, delete the created file
                    resolver.delete(uri, null, null)
                    false
                }
            } else {
                false
            }
        } else {
            // This should not happen as we're targeting Android 10+
            return false
        }
    }
}
