package com.example.homewidgetdemo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class MyHomeWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.counter_widget)
            views.setTextViewText(R.id.text_counter, widgetData.getInt("count_key", 0).toString())

            val incrementIntent = Intent(context, this::class.java).apply {
                action = "homeWidgetCounter.INCREMENT" // unique custom action
                data = Uri.parse("homeWidgetCounter://increment")
            }

            val incrementPendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                incrementIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val clearIntent = Intent(context, this::class.java).apply {
                action = "homeWidgetCounter.CLEAR"
                data = Uri.parse("homeWidgetCounter://clear")
            }

            val clearPendingIntent = PendingIntent.getBroadcast(
                context,
                1,
                clearIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val launchAppIntent = Intent(Intent.ACTION_MAIN).apply {
                setClass(context, MainActivity::class.java)
                addCategory(Intent.CATEGORY_LAUNCHER)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val launchAppPendingIntent = PendingIntent.getActivity(
                context,
                3,
                launchAppIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            views.setOnClickPendingIntent(R.id.button_increment, incrementPendingIntent)
            views.setOnClickPendingIntent(R.id.button_clear, clearPendingIntent)
            views.setOnClickPendingIntent(R.id.main_container, launchAppPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        val uri = intent.data
        Log.d("HomeWidget", "onReceive called with URI: $uri")

        if (uri != null) {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            when (uri.toString()) {
                "homeWidgetCounter://increment" -> {
                    val current = prefs.getInt("count_key", 0)
                    Log.d("HomeWidget", "onReceive increment: $current")
                    prefs.edit().putInt("count_key", current + 1).apply()
                }

                "homeWidgetCounter://clear" -> {
                    prefs.edit().putInt("count_key", 0).apply()
                }
            }

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, this::class.java))
            onUpdate(context, appWidgetManager, widgetIds, prefs)
        } else {
            Log.e("HomeWidget", "Intent URI was null")
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.counter_widget)
    views.setTextViewText(R.id.text_counter, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}