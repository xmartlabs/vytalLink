package com.xmartlabs.vytalLink

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var deepLinkChannel: MethodChannel? = null
    private val pendingDeepLinks = mutableListOf<String>()
    private var isFlutterReady = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enqueueDeepLink(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        deepLinkChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEEP_LINK_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "activate" -> {
                        isFlutterReady = true
                        result.success(ArrayList(pendingDeepLinks))
                        pendingDeepLinks.clear()
                    }

                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        enqueueDeepLink(intent)
    }

    private fun enqueueDeepLink(intent: Intent?) {
        val deepLink = intent
            ?.takeIf { it.action == Intent.ACTION_VIEW }
            ?.dataString
            ?: return

        dispatchDeepLink(deepLink)
    }

    private fun dispatchDeepLink(deepLink: String) {
        val channel = deepLinkChannel
        if (!isFlutterReady || channel == null) {
            pendingDeepLinks.add(deepLink)
            return
        }

        channel.invokeMethod("onDeepLink", deepLink)
    }

    companion object {
        private const val DEEP_LINK_CHANNEL = "com.xmartlabs.vytallink/deep_links"
    }
}
