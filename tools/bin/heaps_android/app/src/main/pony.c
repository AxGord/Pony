#define HL_NAME(n) pony_##n

#include <hl.h>
#include <jni.h>
#include <android/asset_manager.h>

AAssetManager* mgr;

HL_PRIM const char *HL_NAME(get_pref_path)(const char *org, const char *app) {
	return SDL_GetPrefPath(org, app);
}

HL_PRIM vbyte *HL_NAME(get_asset)(const char *filename) {
	if (mgr == NULL) {
		JNIEnv* env = (JNIEnv*)SDL_AndroidGetJNIEnv();
		jobject activity = (jobject)SDL_AndroidGetActivity();
		jclass activity_class = (*env)->GetObjectClass(env, activity);
		jmethodID activity_class_getAssets = (*env)->GetMethodID(env, activity_class, "getAssets", "()Landroid/content/res/AssetManager;");
		jobject asset_manager = (*env)->CallObjectMethod(env, activity, activity_class_getAssets);
		mgr = (AAssetManager*)AAssetManager_fromJava(env, asset_manager);
	}
	AAsset *asset = AAssetManager_open(mgr, filename, AASSET_MODE_STREAMING);

	int length = AAsset_getLength64(asset);
	char c[length + sizeof(length)];
	for (int i = 0; i < sizeof(length); i++) c[i] = ((char*)&length)[i];
	AAsset_read(asset, c + sizeof(length), length);
	vbyte* bytes = hl_copy_bytes(c, length + sizeof(length));
	return bytes;
}
