#import <Foundation/Foundation.h>

#define INTERSTITIAL_PLACEMENT_DEFAULT @"default"
#define INTERSTITIAL_PLACEMENT_LEVEL_COMPLETED @"level_completed"

#define REWARDED_PLACEMENT_SUCCESS @"SUCCESS"
#define REWARDED_PLACEMENT_HELPER @"HELPER"
#define REWARDED_PLACEMENT_NEUTRAL @"NEUTRAL"

typedef enum {
   REWARDTYPE_ITEM = 1,
   REWARDTYPE_COINS,
} RewardType;

typedef enum {
   POSITION_TOP = 1,
   POSITION_BOTTOM,
} Position;

@protocol CurrencyGrantedDelegate<NSObject>

-(void)onCurrencyGranted:(int)amount;

@end

@protocol RewardDelegate<NSObject>

-(void)onRewardGranted:(int)rewardValue rewardType:(RewardType)rewardType;
-(void)onRewardDeclined;
-(void)onRewardUnavailable;

@end

@interface FglEnhance : NSObject {
}

+(id)sharedInstance;
-(void)setCurrencyGrantedDelegate:(id)delegate;
-(BOOL)isEnhanced;
-(BOOL)isInterstitialReady;
-(BOOL)isInterstitialReady:(NSString*)placement;
-(void)showInterstitial;
-(void)showInterstitial:(NSString*)placement;
-(BOOL)isRewardedAdReady;
-(BOOL)isRewardedAdReady:(NSString*)placement;
-(void)showRewardedAd:(id)delegate;
-(void)showRewardedAd:(id)delegate placement:(NSString*)placement;
-(BOOL)isFullscreenAdShowing;
-(void)showOverlayAd:(Position)position;
-(void)hideOverlayAd;
-(BOOL)isSpecialOfferReady;
-(void)showSpecialOffer;
-(BOOL)isOfferwallReady;
-(void)showOfferwall;
-(void)logEvent:(NSString*)eventType;
-(void)logEvent:(NSString*)eventType withParameter:(NSString*)paramKey andValue:(NSString*)paramValue;

@end
