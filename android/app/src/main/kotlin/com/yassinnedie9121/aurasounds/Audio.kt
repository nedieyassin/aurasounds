package com.yassinnedie9121.aurasounds

import android.app.*
import android.net.Uri
import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.os.ParcelFileDescriptor
import java.io.FileDescriptor
import java.io.IOException

class Audio(
    var id: Long,
    var data: String,
    var title: String,
    var album: String,
//    var genre: String,
    var artist: String,
    var albumId: Long,
    var duration: Long,
    var albumPathUri: String
) {
    public fun getArtBitmap(context: Context): Bitmap? {
        try {
            val parcelFileDescriptor: ParcelFileDescriptor? =
                context.contentResolver.openFileDescriptor(Uri.parse(albumPathUri), "r")
            val fileDescriptor: FileDescriptor = parcelFileDescriptor!!.fileDescriptor
            val image = BitmapFactory.decodeFileDescriptor(fileDescriptor)

            parcelFileDescriptor.close()
            return image;
        } catch (e: IOException) {

            return null;
        }
    }
}