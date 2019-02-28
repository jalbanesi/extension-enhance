#include <hx/CFFI.h>
#include "Utils.h"
#include <stdio.h>
#include <sys/types.h>

extern "C" {
   void enhanceglue_initialize (AutoGCRoot *eventHandle);
   bool enhanceglue_isInterstitialReady (const char *placement);
   void enhanceglue_showInterstitialAd (const char *placement);
   bool enhanceglue_isRewardedAdReady (const char *placement);
   void enhanceglue_showRewardedAd (const char *placement);
   bool enhanceglue_isSpecialOfferReady ();
   void enhanceglue_showSpecialOffer ();
   bool enhanceglue_isOfferwallReady ();
   void enhanceglue_showOfferwall ();
   void enhanceglue_logEvent (const char *eventType, const char *paramKey, const char *paramValue);
}

