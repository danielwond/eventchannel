package com.example.untitled3

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.plugin.common.EventChannel

class MyStreamHandler(context: Context) : EventChannel.StreamHandler {
    val cxt = context
    private var reciever:BroadcastReceiver?=null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if(events == null) return
        reciever = initReciever(events)
        cxt.registerReceiver(reciever, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    override fun onCancel(arguments: Any?) {
        cxt.unregisterReceiver(reciever)
        reciever = null
    }

    private fun initReciever(events: EventChannel.EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                when(status){
                    BatteryManager.BATTERY_STATUS_CHARGING -> events.success("its charging foo")
                    BatteryManager.BATTERY_STATUS_FULL -> events.success("its full foo")
                    BatteryManager.BATTERY_STATUS_DISCHARGING -> events.success("its discharging foo")

                }
            }
        }
    }

}