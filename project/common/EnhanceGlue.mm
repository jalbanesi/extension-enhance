#import "EnhanceGlue.h"
#import "FglEnhance.h"

AutoGCRoot *enhanceEventHandle = 0;

@interface EnhanceOpenFLRewardDelegate : NSObject<RewardDelegate> {
}

@end

@implementation EnhanceOpenFLRewardDelegate

-(void)onRewardGranted:(int)rewardValue rewardType:(RewardType)rewardType {
   NSLog (@"EnhanceOpenFLExtension: onRewardGranted rewardValue:%d rewardType:%@",
          rewardValue, rewardType == REWARDTYPE_COINS ? @"coins": @"item");
   value o = alloc_empty_object();
   alloc_field(o,val_id("evt"),alloc_string("onRewardGranted"));
   alloc_field(o,val_id("rewardValue"),alloc_int(rewardValue));
   alloc_field(o,val_id("rewardType"),alloc_string((rewardType == REWARDTYPE_COINS) ? "coins": "item"));
   val_call1(enhanceEventHandle->get(), o);
}

-(void)onRewardDeclined {
   NSLog (@"EnhanceOpenFLExtension: onRewardDeclined");
   value o = alloc_empty_object();
   alloc_field(o,val_id("evt"),alloc_string("onRewardDeclined"));
   val_call1(enhanceEventHandle->get(), o);
}

-(void)onRewardUnavailable {
   NSLog (@"EnhanceOpenFLExtension: onRewardUnavailable");
   value o = alloc_empty_object();
   alloc_field(o,val_id("evt"),alloc_string("onRewardUnavailable"));
   val_call1(enhanceEventHandle->get(), o);
}

@end

EnhanceOpenFLRewardDelegate *g_rewardDelegate;

void enhanceglue_initialize (AutoGCRoot *eventHandle) {
   NSLog (@"EnhanceOpenFLExtension: initialize");
   enhanceEventHandle = eventHandle;
   g_rewardDelegate = [[EnhanceOpenFLRewardDelegate alloc] init];
}

bool enhanceglue_isInterstitialReady (const char *placement) {
   NSString *placementNS = [NSString stringWithUTF8String:placement];
   return [[FglEnhance sharedInstance] isInterstitialReady:placementNS];
}

void enhanceglue_showInterstitialAd (const char *placement) {
   NSString *placementNS = [NSString stringWithUTF8String:placement];
   NSLog (@"EnhanceOpenFLExtension: showInterstitialAd for %@", placementNS);
   [[FglEnhance sharedInstance] showInterstitial:[NSString stringWithUTF8String:placement]];
}

bool enhanceglue_isRewardedAdReady (const char *placement) {
   NSString *placementNS = [NSString stringWithUTF8String:placement];
   return [[FglEnhance sharedInstance] isRewardedAdReady:placementNS];
}

void enhanceglue_showRewardedAd (const char *placement) {
   NSString *placementNS = [NSString stringWithUTF8String:placement];
   return [[FglEnhance sharedInstance] showRewardedAd:g_rewardDelegate placement:placementNS];
}

bool enhanceglue_isSpecialOfferReady () {
   return [[FglEnhance sharedInstance] isSpecialOfferReady];
}

void enhanceglue_showSpecialOffer () {
   [[FglEnhance sharedInstance] showSpecialOffer];
}

bool enhanceglue_isOfferwallReady () {
   return [[FglEnhance sharedInstance] isOfferwallReady];
}

void enhanceglue_showOfferwall () {
   [[FglEnhance sharedInstance] showOfferwall];
}

void enhanceglue_logEvent (const char *eventType, const char *paramKey, const char *paramValue) {
   NSString *eventTypeNS = [NSString stringWithUTF8String:eventType];
   NSString *paramKeyNS = paramKey ? [NSString stringWithUTF8String:paramKey] : nil;
   NSString *paramValueNS = paramValue ? [NSString stringWithUTF8String:paramValue] : nil;
   
   if (paramKeyNS != nil && paramValueNS != nil) {
      NSLog (@"EnhanceOpenFLExtension: logEvent %@ with %@=%@", eventTypeNS, paramKeyNS, paramValueNS);
      [[FglEnhance sharedInstance] logEvent:eventTypeNS withParameter:paramKeyNS andValue:paramValueNS];
   }
   else {
      NSLog (@"EnhanceOpenFLExtension: logEvent %@", eventTypeNS);
      [[FglEnhance sharedInstance] logEvent:eventTypeNS];
   }
}
