package com.devcon7.djizhub

import android.os.Bundle
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent: Intent = getIntent()
        val data: Uri? = intent.getData()
        if (data != null) {
            // Manipulez l'URI ici, extrayez les informations pertinentes
            // et naviguez vers l'écran approprié dans votre application.
        }
    }

}
