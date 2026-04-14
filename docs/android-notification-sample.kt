// Example Kotlin skeleton for an Android BroadcastReceiver that listens to notifications
// and forwards parsed transaction payloads to Flutter via MethodChannel.

package com.example.finance

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class NotificationReceiver(private val flutterEngine: FlutterEngine) : BroadcastReceiver() {
    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "finance/notifications")

    override fun onReceive(context: Context?, intent: Intent?) {
        // Parse the intent or notification extras
        val extras = intent?.extras
        val map: MutableMap<String, Any?> = HashMap()
        if (extras != null) {
            // Example: the notification contains amount and description
            map["id"] = extras.getString("id")
            map["amount"] = extras.getDouble("amount", 0.0)
            map["currency"] = extras.getString("currency") ?: "KZT"
            map["timestamp"] = extras.getString("timestamp")
            map["description"] = extras.getString("description")
        }

        // Send to Flutter
        channel.invokeMethod("onNotification", map)
    }
}
