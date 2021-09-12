package io.heaps.android;

import org.libsdl.app.SDLActivity;
import android.content.Context;
import android.os.Bundle;

public class HeapsActivity extends SDLActivity {

    private static HeapsActivity instance;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        instance = this;
    }

    @Override
    protected String[] getLibraries() {
        return new String[]{
            "openal",
            "SDL2",
            "heapsapp"
        };
    }

    public static Context getContext() {
        return instance.getApplicationContext();
    }

}
