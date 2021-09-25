#define HL_NAME(n) pony_##n

#include <hl.h>
#include <jni.h>
#include <android/asset_manager.h>
#include <android/log.h>

#define LOG_TAG "Pony"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

AAssetManager* mgr;
AAsset *asset;

HL_PRIM const char *HL_NAME(get_pref_path)(const char *org, const char *app) {
	return SDL_GetPrefPath(org, app);
}

HL_PRIM int HL_NAME(get_asset)(const char *filename) {
	if (mgr == NULL) {
		JNIEnv* env = (JNIEnv*)SDL_AndroidGetJNIEnv();
		jobject activity = (jobject)SDL_AndroidGetActivity();
		jclass activity_class = (*env)->GetObjectClass(env, activity);
		jmethodID activity_class_getAssets = (*env)->GetMethodID(env, activity_class, "getAssets", "()Landroid/content/res/AssetManager;");
		jobject asset_manager = (*env)->CallObjectMethod(env, activity, activity_class_getAssets);
		mgr = (AAssetManager*)AAssetManager_fromJava(env, asset_manager);
	}
	asset = AAssetManager_open(mgr, filename, AASSET_MODE_STREAMING);
	off_t length = AAsset_getLength(asset);
	LOGI("Get asset: %s, length: %d", filename, length);
	return length;
}

HL_PRIM vbyte *HL_NAME(get_asset_bytes)(int length) {
	char c[length];
	AAsset_read(asset, c, length);
	vbyte* bytes = hl_copy_bytes(c, length);
	return bytes;
}

HL_PRIM void HL_NAME(finish_get_asset)(int length) {
	asset = NULL;
	LOGI("Finish get asset");
}