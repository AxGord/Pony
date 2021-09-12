#include <jni.h>

extern int main(int argc, char *argv[]); // assuming that haxe->hl/c entry point is included (which includes hlc_main.c which includes the main function)

JNIEXPORT int JNICALL Java_io_heaps_android_HeapsMain_startHL(JNIEnv* env, jclass cls) {
    return main(0, NULL);
}
