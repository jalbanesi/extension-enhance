#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"

#include "EnhanceGlue.h"

using namespace enhanceopenflextension;

#if defined(__APPLE__)

static value enhanceopenflextension_initialize (value onEvent) {
   enhanceglue_initialize(new AutoGCRoot(onEvent));
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_initialize, 1);

static value enhanceopenflextension_isInterstitialReady (value placement) {
   return alloc_bool (enhanceglue_isInterstitialReady(val_string(placement)));
}
DEFINE_PRIM (enhanceopenflextension_isInterstitialReady, 1);

static value enhanceopenflextension_showInterstitialAd (value placement) {
   enhanceglue_showInterstitialAd(val_string(placement));
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_showInterstitialAd, 1);

static value enhanceopenflextension_isRewardedAdReady (value placement) {
   return alloc_bool (enhanceglue_isRewardedAdReady(val_string(placement)));
}
DEFINE_PRIM (enhanceopenflextension_isRewardedAdReady, 1);

static value enhanceopenflextension_showRewardedAd (value placement) {
   enhanceglue_showRewardedAd(val_string(placement));
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_showRewardedAd, 1);

static value enhanceopenflextension_isSpecialOfferReady () {
   return alloc_bool (enhanceglue_isSpecialOfferReady());
}
DEFINE_PRIM (enhanceopenflextension_isSpecialOfferReady, 0);

static value enhanceopenflextension_showSpecialOffer () {
   enhanceglue_showSpecialOffer();
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_showSpecialOffer, 0);

static value enhanceopenflextension_isOfferwallReady () {
   return alloc_bool (enhanceglue_isOfferwallReady());
}
DEFINE_PRIM (enhanceopenflextension_isOfferwallReady, 0);

static value enhanceopenflextension_showOfferwall () {
   enhanceglue_showOfferwall();
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_showOfferwall, 0);

static value enhanceopenflextension_logEvent (value eventType, value paramKey, value paramValue) {
   enhanceglue_logEvent(val_string(eventType),val_string(paramKey),val_string(paramValue));
   return alloc_null();
}
DEFINE_PRIM (enhanceopenflextension_logEvent, 3);

#endif /* __APPLE__ */

extern "C" void enhanceopenflextension_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (enhanceopenflextension_main);



extern "C" int enhanceopenflextension_register_prims () { return 0; }
