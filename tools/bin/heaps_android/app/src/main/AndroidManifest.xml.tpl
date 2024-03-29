<?xml version="1.0" encoding="utf-8"?>
<manifest
    xmlns:android="http://schemas.android.com/apk/res/android"
    package="::id::"
    android:installLocation="auto"
>
    <!-- OpenGL ES 2.0 -->
    <uses-feature android:glEsVersion="0x00020000" />

    <!-- Allow writing to external storage -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <!-- Allow access to the vibrator -->
    <uses-permission android:name="android.permission.VIBRATE" />

    <!-- if you want to capture audio, uncomment this. -->
    <!-- <uses-permission android:name="android.permission.RECORD_AUDIO" /> -->

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        ::if (roundIcon)::
        android:roundIcon="@mipmap/ic_launcher_round"
        ::end::
        android:allowBackup="true"
        android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
        android:hardwareAccelerated="true"
    >
        <!-- Example of setting SDL hints from AndroidManifest.xml:
        <meta-data android:name="SDL_ENV.SDL_ACCELEROMETER_AS_JOYSTICK" android:value="0"/>
         -->

        <activity
            android:name="io.heaps.android.HeapsActivity"
            android:label="@string/app_name"
            android:configChanges="keyboard|keyboardHidden|orientation|screenSize"
            android:exported="true"
            ::if (fixedOrientation)::
            android:screenOrientation="::orientation::"
            ::end::
        >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <!-- Drop file event -->
            <!--
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>
            -->
        </activity>
    </application>

</manifest>
