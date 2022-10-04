package com.example.next_ble.debugutils

fun ByteArray.toHexString() = joinToString("") { String.format("%02x", it) }
