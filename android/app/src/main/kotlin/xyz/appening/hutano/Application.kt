 package xyz.appening.hutano
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import android.app.Notification 
import android.app.NotificationChannel 
import android.app.NotificationManager 
import android.os.Build 

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { 
      this.registerChannel();
        }
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
    }

    private fun registerChannel(){
         val channel: NotificationChannel = NotificationChannel(
                "Hutano Patient",
                "Hutano Patient",
                NotificationManager.IMPORTANCE_HIGH
        )
        val manager:NotificationManager = getSystemService(NotificationManager::class.java) as NotificationManager
        manager.createNotificationChannel(channel)
        
    }

}