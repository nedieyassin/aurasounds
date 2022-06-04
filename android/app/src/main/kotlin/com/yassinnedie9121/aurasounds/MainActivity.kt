package com.yassinnedie9121.aurasounds

import android.content.ContentUris
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.PermissionChecker
import io.flutter.embedding.android.FlutterActivity
import android.Manifest
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nedieyassin/auro"
    private var playlist = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPlaylist" -> {
                    val storage = StorageUtils(applicationContext)
                    result.success(storage.loadAudio());
                }
                "invokeList" -> {
                    getPlaylist()
                    result.success(true)
                }
                "lastSynced" -> {
                    val storage = StorageUtils(applicationContext)
                    result.success(storage.loadTimestamp())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }


    }

    private fun getPlaylist() {
        GlobalScope.launch {
            val playlist = loadAudio();
            val storage = StorageUtils(applicationContext)
            storage.storeAudio(playlist)
            storage.storeTimestamp(System.currentTimeMillis())
        }
    }


    private suspend fun loadAudio(): String {
        requestPermission()
        val __audioList: ArrayList<Audio?> = ArrayList()
        val gson = Gson()


        withContext(Dispatchers.IO) {

            val projection = arrayOf(
                MediaStore.Audio.Media._ID,
                MediaStore.Audio.Media.TITLE,
                MediaStore.Audio.Media.ALBUM,
                MediaStore.Audio.Media.ARTIST,
                MediaStore.Audio.Media.ALBUM_ID,
                MediaStore.Audio.Media.DURATION,
                MediaStore.Audio.Media.DATA,
                MediaStore.Audio.Media.GENRE,

            )

            val selection = MediaStore.Audio.Media.IS_MUSIC + "!= 0"
            val sortOrder = MediaStore.Audio.Media.TITLE + " ASC"



            contentResolver.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                projection,
                selection, // selection
                null, // selectionArgs
                sortOrder
            )?.use { cursor ->
                val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
                val albumColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.ALBUM)
                val artistColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.ARTIST)
                val titleColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
                val uriColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
                val durationColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
                val albumIdColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM_ID)


                while (cursor.moveToNext()) {
                    val id = cursor.getLong(idColumn)
                    val title = cursor.getString(titleColumn)
                    val album = cursor.getString(albumColumn)
                    val artist = cursor.getString(artistColumn)
                    val uri = cursor.getString(uriColumn)
                    val albumId = cursor.getLong(albumIdColumn)
                    val duration = cursor.getLong(durationColumn)
                    val albumArtPath: Uri = Uri.parse("content://media/external/audio/albumart")
                    val albumPathUri: Uri = ContentUris.withAppendedId(albumArtPath, albumId)
                    __audioList.add(
                        Audio(
                            id,
                            uri,
                            title,
                            album,
                            artist,
                            albumId,
                            duration,
                            albumPathUri.toString()
                        )
                    )
//                    Log.e("msg", uri.toString())
                }
            }


        }
        return gson.toJson(__audioList);
    }


    //
    private fun haveStoragePermission() =
        ContextCompat.checkSelfPermission(
            this, Manifest.permission.READ_EXTERNAL_STORAGE
        ) == PermissionChecker.PERMISSION_GRANTED

    //
    private fun requestPermission() {

        if (!haveStoragePermission()) {
            val permissions = arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE)
            ActivityCompat.requestPermissions(this, permissions, 0x1045)
        }
    }

}
