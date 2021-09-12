package io.heaps.android;

public class HeapsMain implements Runnable {

    private static native int startHL();

	@Override
    public void run() {
        startHL();
    }

}