package com.yassinnedie9121.aurasounds

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson


class StorageUtils(private val context: Context) {

    private val STORAGE = " com.nedieyassin.aura.STORAGE"

    private var preferences: SharedPreferences? = null

    fun storeAudio(list: String?) {
        preferences = context.getSharedPreferences(STORAGE, Context.MODE_PRIVATE)
        val editor = preferences!!.edit()
        editor.putString("audioArrayList", list)
        editor.apply()
    }

    fun loadAudio(): String? {
        preferences = context.getSharedPreferences(STORAGE, Context.MODE_PRIVATE)
        return preferences!!.getString("audioArrayList", null)
    }

    fun storeTimestamp(index: Long) {
        preferences = context.getSharedPreferences(STORAGE, Context.MODE_PRIVATE)
        val editor = preferences!!.edit()
        editor.putLong("timestamp", index)
        editor.apply()
    }

    fun loadTimestamp(): Long {
        preferences = context.getSharedPreferences(STORAGE, Context.MODE_PRIVATE)
        return preferences!!.getLong("timestamp", -1) //return -1 if no data found
    }

    fun clearCachedAudioPlaylist() {
        preferences = context.getSharedPreferences(STORAGE, Context.MODE_PRIVATE)
        val editor = preferences!!.edit()
        editor.clear()
        editor.apply()
    }

}