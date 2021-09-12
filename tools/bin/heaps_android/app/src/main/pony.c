#define HL_NAME(n) pony_##n

#include <hl.h>

HL_PRIM const char *HL_NAME(get_pref_path)(const char *org, const char *app) {
	return SDL_GetPrefPath(org, app);
}