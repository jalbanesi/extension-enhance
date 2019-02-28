#import "FglEnhance.h"
#import <UIKit/UIAlertController.h>
#import <UIKit/UIWindow.h>

@interface FglEnhance()

@property(strong, nonatomic)id currencyGrantedDelegate;
@property(strong, nonatomic)id rewardedAdsDelegate;
@property(nonatomic, assign) BOOL flagIsEnhanced;
@property(strong,nonatomic) NSMutableSet *readyInterstitialPlacements;
@property(nonatomic, assign) BOOL flagInterstitialShowing;
@property(strong,nonatomic) NSMutableSet *readyRewardedAdPlacements;
@property(nonatomic, assign) BOOL flagRewardedAdReady;
@property(nonatomic, assign) BOOL flagRewardedAdShowing;
@property(nonatomic, assign) BOOL flagSpecialOfferReady;
@property(nonatomic, assign) BOOL flagOfferwallReady;
@property(nonatomic, assign) BOOL flagOfferwallShowing;

@end

@implementation FglEnhance

@synthesize currencyGrantedDelegate;
@synthesize rewardedAdsDelegate;
@synthesize flagIsEnhanced;
@synthesize readyInterstitialPlacements;
@synthesize flagInterstitialShowing;
@synthesize readyRewardedAdPlacements;
@synthesize flagRewardedAdShowing;
@synthesize flagSpecialOfferReady;
@synthesize flagOfferwallReady;
@synthesize flagOfferwallShowing;

const char *g_szConnectorIDString = "$$FGLEnhanceConnector|" __DATE__ "|" __TIME__ "$$";

/**
 * Get connector singleton
 *
 * @return singleton
 */
+(id)sharedInstance {
   static FglEnhance *singleton = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      singleton = [[self alloc] init];
   });
   return singleton;
}

-(id)init {
   self = [super init];
   if (self != nil) {
      readyInterstitialPlacements = [[NSMutableSet alloc] init];
      readyRewardedAdPlacements = [[NSMutableSet alloc] init];
      
      // Register to receive events from Enhance
      NSLog(@"EnhanceConnector: init");
      rewardedAdsDelegate = nil;
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(onEnhanceEvent:)
                                                   name:@"com.fgl.enhance.event"
                                                 object:nil];
      
      // Check if Enhance settings are present
      NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Frameworks/enhance.framework/FGLEnhance" ofType:@"plist"]];
      if (settings == nil)
         settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FGLEnhance" ofType:@"plist"]];
      flagIsEnhanced = settings != nil;

      // Ask Enhance to refresh the ads state
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      [dict setObject:@"refreshState" forKey:@"command"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
   }
   
   return self;
}

/**
 * Set delegate for receiving currency callbacks
 *
 * @param delegate new delegate
 */
-(void)setCurrencyGrantedDelegate:(id)delegate {
   currencyGrantedDelegate = delegate;
}

/**
 * Check if application is enhanced
 *
 * @return YES if enhanced, false if not
 */
-(BOOL)isEnhanced {
   return flagIsEnhanced;
}

/**
 * Check if an interstitial is ready to show
 *
 * @return YES if an interstitial is ready to show, false if not
 */
-(BOOL)isInterstitialReady {
   return [self isInterstitialReady:INTERSTITIAL_PLACEMENT_DEFAULT];
}

/**
 * Check if an interstitial is ready to show
 *
 * @param placement placement type (INTERSTITIAL_PLACEMENT_xxx) to check for
 *
 * @return YES if an interstitial is ready to show, false if not
 */
-(BOOL)isInterstitialReady:(NSString*)placement {
   return ([readyInterstitialPlacements containsObject:[placement lowercaseString]]) || (flagIsEnhanced == NO);
}

/**
 * Show an interstitial ad if one is ready
 */
-(void)showInterstitial {
   [self showInterstitial:INTERSTITIAL_PLACEMENT_DEFAULT];
}

/**
 * Show an interstitial ad if one is ready
 *
 * @param placement placement type (INTERSTITIAL_PLACEMENT_xxx) to show ad for
 */
-(void)showInterstitial:(NSString*)placement {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"showInterstitial" forKey:@"command"];
   if (placement != nil && [[placement lowercaseString] isEqualToString:@"default"] == NO)
      [dict setObject:[placement lowercaseString] forKey:@"placement"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
   
   if ([self isEnhanced] == NO) {
      // Show feedback popup
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enhance interstitial" message:@"Well done! An actual interstitial will show here when your app is Enhanced." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      }];
      [alert addAction:defaultAction];
      [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
   }
}

/**
 * Check if a rewarded as is ready to show
 *
 * @return YES if a rewarded ad is ready to show, false if not
 */
-(BOOL)isRewardedAdReady {
   return [self isRewardedAdReady:REWARDED_PLACEMENT_NEUTRAL];
}

/**
 * Check if a rewarded as is ready to show
 *
 * @param placement placement type (REWARDED_PLACEMENT_xxx) to check for
 *
 * @return YES if a rewarded ad for this placement is ready to show, false if not
 */
-(BOOL)isRewardedAdReady:(NSString*)placement {
   return ([readyRewardedAdPlacements containsObject:[placement uppercaseString]]) || (flagIsEnhanced == NO);
}

/**
 * Show a rewarded ad if one is ready
 *
 * @param delegate delegate to call upon rewarded ad events
 */
-(void)showRewardedAd:(id)delegate {
   [self showRewardedAd:delegate placement:REWARDED_PLACEMENT_NEUTRAL];
}

/**
 * Show a rewarded ad if one is ready
 *
 * @param delegate delegate to call upon rewarded ad events
 * @param placement placement type (PLACEMENT_xxx)
 */
-(void)showRewardedAd:(id)delegate placement:(NSString*)placement {
   rewardedAdsDelegate = delegate;
   
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"showRewardedAd" forKey:@"command"];
   [dict setObject:[placement uppercaseString] forKey:@"placement"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
   
   if ([self isEnhanced] == NO) {
      // Show feedback popup
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enhance rewarded ad" message:@"Well done! An actual rewarded ad will show here when your app is Enhanced." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         if (rewardedAdsDelegate != nil)
            [rewardedAdsDelegate onRewardGranted:0 rewardType:REWARDTYPE_ITEM];
      }];
      [alert addAction:defaultAction];
      [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
   }
}

/**
 * Check if a fullscreen, modal ad is currently showing
 *
 * @return YES if showing, NO otherwise
 */
-(BOOL)isFullscreenAdShowing {
   return flagInterstitialShowing || flagRewardedAdShowing || flagOfferwallShowing;
}

/**
 * Show an overlay (banner) ad
 *
 * @param position ad position (POSITION_xxx)
 */
-(void)showOverlayAd:(Position)position {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"showOverlayAd" forKey:@"command"];
   if (position == POSITION_BOTTOM)
      [dict setObject:@"BOTTOM" forKey:@"position"];
   else
      [dict setObject:@"TOP" forKey:@"position"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
}

/**
 * Hide currently showing overlay ad, if any
 */
-(void)hideOverlayAd {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"hideOverlayAd" forKey:@"command"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
}

-(BOOL)isSpecialOfferReady {
   return flagSpecialOfferReady || (flagIsEnhanced == NO);
}

-(void)showSpecialOffer {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"showSpecialOffer" forKey:@"command"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
   
   if ([self isEnhanced] == NO) {
      // Show feedback popup
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Special offer" message:@"Well done! An actual offer will show here when your app is Enhanced." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      }];
      [alert addAction:defaultAction];
      [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
   }
}

/**
 * Check if an offerwall is ready to show
 *
 * @return YES if an offerwall is ready to show, false if not
 */
-(BOOL)isOfferwallReady {
   return flagOfferwallReady || (flagIsEnhanced == NO);
}

/**
 * Show an offerwall if one is ready
 */
-(void)showOfferwall {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"showOfferwall" forKey:@"command"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
   
   if ([self isEnhanced] == NO) {
      // Show feedback popup
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enhance offerwall" message:@"Well done! An actual offerwall will show here when your app is Enhanced." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      }];
      [alert addAction:defaultAction];
      [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
   }
}

/**
 * Log application event
 *
 * @param eventType event type (name)
 */
-(void)logEvent:(NSString*)eventType {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"logCustomEvent" forKey:@"command"];
   [dict setObject:eventType forKey:@"eventType"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
}

/**
 * Log application event
 *
 * @param eventType event type (name)
 * @param withParameter parameter key
 * @param andValue parameter value
 */
-(void)logEvent:(NSString*)eventType withParameter:(NSString*)paramKey andValue:(NSString*)paramValue {
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   [dict setObject:@"logCustomEvent" forKey:@"command"];
   [dict setObject:eventType forKey:@"eventType"];
   [dict setObject:paramKey forKey:@"param1Key"];
   [dict setObject:paramValue forKey:@"param1Value"];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"com.fgl.enhance.command" object:dict];
}

// Handle Enhance events

-(void)onEnhanceEvent:(NSNotification *)notification {
   if (notification != nil && notification.object != nil) {
      NSDictionary *dict = (NSDictionary *) notification.object;
      NSString *eventType = [dict valueForKey:@"type"];
      
      if (eventType != nil) {
         if ([eventType isEqualToString:@"onInterstitialReadyForPlacement"]) {
            NSString *placementName = [dict valueForKey:@"placement"];
            NSLog(@"EnhanceConnector: onInterstitialReadyForPlacement: %@", placementName);
            if (placementName != nil && [readyRewardedAdPlacements containsObject:placementName] == NO) {
               [readyInterstitialPlacements addObject:placementName];
            }
         }
         else if ([eventType isEqualToString:@"onInterstitialUnavailable"]) {
            NSString *placementName = [dict valueForKey:@"placement"];
            
            NSLog(@"EnhanceConnector: onInterstitialUnavailable: %@", placementName);
            if (placementName != nil && [readyRewardedAdPlacements containsObject:placementName] == YES) {
               [readyInterstitialPlacements removeObject:placementName];
            }
         }
         else if ([eventType isEqualToString:@"onInterstitialShowing"]) {
            flagInterstitialShowing = YES;
         }
         else if ([eventType isEqualToString:@"onInterstitialCompleted"]) {
            flagInterstitialShowing = NO;
         }
         else if ([eventType isEqualToString:@"onRewardedAdReadyForPlacement"]) {
            NSString *placementName = [dict valueForKey:@"placement"];
            NSLog(@"EnhanceConnector: onRewardedAdReadyForPlacement: %@", placementName);
            if (placementName != nil && [readyRewardedAdPlacements containsObject:placementName] == NO) {
               [readyRewardedAdPlacements addObject:placementName];
            }
         }
         else if ([eventType isEqualToString:@"onRewardedAdUnavailableForPlacement"]) {
            NSString *placementName = [dict valueForKey:@"placement"];
            
            NSLog(@"EnhanceConnector: onRewardedAdUnavailableForPlacement: %@", placementName);
            if (placementName != nil && [readyRewardedAdPlacements containsObject:placementName] == YES) {
               [readyRewardedAdPlacements removeObject:placementName];
            }
         }
         else if ([eventType isEqualToString:@"onRewardedAdShowing"]) {
            flagRewardedAdShowing = YES;
         }
         else if ([eventType isEqualToString:@"onRewardedAdCompleted"]) {
            flagRewardedAdShowing = NO;
         }
         else if ([eventType isEqualToString:@"onRewardGranted"]) {
            NSNumber *rewardValueNum = [dict valueForKey:@"rewardValue"];
            NSString *rewardTypeStr = [dict valueForKey:@"rewardType"];
            RewardType rewardType;
            
            if ([rewardTypeStr isEqualToString:@"ITEM"])
               rewardType = REWARDTYPE_ITEM;
            else
               rewardType = REWARDTYPE_COINS;
            
            if (rewardedAdsDelegate != nil)
               [rewardedAdsDelegate onRewardGranted:[rewardValueNum intValue] rewardType:rewardType];
            rewardedAdsDelegate = nil;
         }
         else if ([eventType isEqualToString:@"onRewardDeclined"]) {
            if (rewardedAdsDelegate != nil)
               [rewardedAdsDelegate onRewardDeclined];
            rewardedAdsDelegate = nil;
         }
         else if ([eventType isEqualToString:@"onRewardUnavailable"]) {
            if (rewardedAdsDelegate != nil)
               [rewardedAdsDelegate onRewardUnavailable];
            rewardedAdsDelegate = nil;
         }
         else if ([eventType isEqualToString:@"onSpecialOfferReady"]) {
            flagSpecialOfferReady = YES;
         }
         else if ([eventType isEqualToString:@"onSpecialOfferUnavailable"]) {
            flagSpecialOfferReady = NO;
         }
         else if ([eventType isEqualToString:@"onOfferwallReady"]) {
            flagOfferwallReady = YES;
         }
         else if ([eventType isEqualToString:@"onOfferwallUnavailable"]) {
            flagOfferwallReady = NO;
         }
         else if ([eventType isEqualToString:@"onOfferwallShowing"]) {
            flagOfferwallShowing = YES;
         }
         else if ([eventType isEqualToString:@"onOfferwallCompleted"]) {
            flagOfferwallShowing = NO;
         }
         else if ([eventType isEqualToString:@"currencyGranted"]) {
            NSString *amountValue = [dict valueForKey:@"amount"];
            if (amountValue != nil) {
               int amount = [amountValue intValue];
               if (currencyGrantedDelegate != nil)
                  [currencyGrantedDelegate onCurrencyGranted:amount];
            }
         }
      }
   }
}

@end
