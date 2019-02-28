package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import lime.system.JNI;
#end

class EnhanceOpenFLExtension {
   private static var mInstance:EnhanceOpenFLExtension = null;   
   private static var mOnRewardGranted:String->Int->Void = null;
   private static var mOnRewardDeclined:Void->Void = null;
   private static var mOnRewardUnavailable:Void->Void = null;

   // Interstitial placement type
   public static inline var INTERSTITIAL_PLACEMENT_SUCCESS:String = "DEFAULT";          // Default placement
   public static inline var INTERSTITIAL_PLACEMENT_HELPER:String = "LEVEL_COMPLETED";   // Level completed placement

   // Rewarded placement type
   public static inline var REWARDED_PLACEMENT_SUCCESS:String = "SUCCESS";              // Ad following success in the game, such as completing a level
   public static inline var REWARDED_PLACEMENT_HELPER:String = "HELPER";                // Ad to help the user, for instance after losing a level or when needing currency
   public static inline var REWARDED_PLACEMENT_NEUTRAL:String = "NEUTRAL";              // Ad in a neutral circumstance, for instance the user tapping "Watch video for a reward"

   // Reward type, passed to the reward granted function
   public static inline var REWARD_ITEM:String = "ITEM";                                // Arbitrary game-defined item granted (no coin amount reported)
   public static inline var REWARD_COINS:String = "COINS";                              // A defined coins amount was granted

   /**
    * Constructor
    */
   public function new() {
   }
   
   /**
    * Get instance of Enhance SDK
    *
    * @return instance
    */      
   private static function getInstance() : EnhanceOpenFLExtension {
      if (mInstance == null) {
         mInstance = new EnhanceOpenFLExtension();
         #if (ios)
         EnhanceOpenFLExtension_initialize(onEventDispatch);
         #end
         #if (android)
         EnhanceOpenFLExtension_initialize(mInstance);
         #end
      }
      return mInstance;
   }

   /**
    * Check if an interstitial ad is ready
    *
    * @param placement placement name for this ad
    *
    * @return true if an interstitial ad is ready, false if not
    */
   public static function isInterstitialAdReady(placement:String=INTERSTITIAL_PLACEMENT_SUCCESS):Bool {
      return getInstance()._isInterstitialAdReady(placement);
   }

   private function _isInterstitialAdReady(placement:String):Bool {
      #if (ios || android)
      return EnhanceOpenFLExtension_isInterstitialReady(placement);
      #else
      return false;
      #end
   }
   
   /**
    * Show interstitial ad
    *
    * @param placement placement name for this ad
    */
   public static function showInterstitialAd(placement:String=INTERSTITIAL_PLACEMENT_SUCCESS): Void {
      getInstance()._showInterstitialAd(placement);
   }

   private function _showInterstitialAd(placement:String): Void {
      #if (ios || android)
      EnhanceOpenFLExtension_showInterstitialAd(placement);
      #end
   }

   /**
    * Check if a rewarded ad is ready
    *
    * @param placement placement name for this ad
    *
    * @return true if a rewarded ad is ready, false if not
    */
   public static function isRewardedAdReady(placement:String=REWARDED_PLACEMENT_NEUTRAL):Bool {
      return getInstance()._isRewardedAdReady(placement);
   }

   private function _isRewardedAdReady(placement:String):Bool {
      #if (ios || android)
      return EnhanceOpenFLExtension_isRewardedAdReady(placement);
      #else
      return false;
      #end
   }

   /**
    * Show rewarded ad
    * 
    * @param placement placement type for this ad, EnhanceConnector.REWARDED_PLACEMENT_SUCCESS, REWARDED_PLACEMENT_HELPER or REWARDED_PLACEMENT_NEUTRAL
    * @param rewardGrantedFunction callback executed when the ad reward is granted
    * @param rewardDeclinedFunction callback executed when the ad reward is declined
    * @param rewardUnavailableFunction callback executed when the ad reward is unavailable
    */
   public static function showRewardedAd(placement:String, onRewardGranted:String->Int->Void, onRewardDeclined:Void->Void, onRewardUnavailable:Void->Void): Void {   
      getInstance()._showRewardedAd(placement, onRewardGranted, onRewardDeclined, onRewardUnavailable);
   }

   private function _showRewardedAd(placement:String, onRewardGranted:String->Int->Void, onRewardDeclined:Void->Void, onRewardUnavailable:Void->Void): Void {   
      mOnRewardGranted = onRewardGranted;   
      mOnRewardDeclined = onRewardDeclined;   
      mOnRewardUnavailable = onRewardUnavailable;   
      #if (ios || android)
      EnhanceOpenFLExtension_showRewardedAd(placement);
      #end
   }

   /**
    * Log custom analytics event
    * 
    * @param eventType event type (for instance 'level_completed')
    * @param paramKey parameter key (for instance 'level')
    * @param paramValue parameter value (for instance '3')
    */
   public static function logEvent(eventType:String, paramKey:String = null, paramValue:String = null) : Void {
	  getInstance()._logEvent(eventType, paramKey, paramValue);
   }

   private function _logEvent(eventType:String, paramKey:String, paramValue:String) : Void {
      #if (ios || android)
      EnhanceOpenFLExtension_logEvent(eventType, paramKey, paramValue);
      #end
   }
      
   /**
    * Check if a special offer is ready
    *
    * @return true if a special offer is ready, false if not
    */
   public static function isSpecialOfferReady():Bool {
      return getInstance()._isSpecialOfferReady();
   }

   private function _isSpecialOfferReady():Bool {
      #if (ios || android)
      return EnhanceOpenFLExtension_isSpecialOfferReady();
      #else
      return false;
      #end
   }
   
   /**
    * Show special offer
    */
   public static function showSpecialOffer(): Void {
      getInstance()._showSpecialOffer();
   }

   private function _showSpecialOffer(): Void {
      #if (ios || android)
      EnhanceOpenFLExtension_showSpecialOffer();
      #end
   }

   /**
    * Check if an offerwall is ready
    *
    * @return true if an offerwall is ready, false if not
    */
   public static function isOfferwallReady():Bool {
      return getInstance()._isOfferwallReady();
   }

   private function _isOfferwallReady():Bool {
      #if (ios || android)
      return EnhanceOpenFLExtension_isOfferwallReady();
      #else
      return false;
      #end
   }
   
   /**
    * Show offerwall
    */
   public static function showOfferwall(): Void {
      getInstance()._showOfferwall();
   }

   private function _showOfferwall(): Void {
      #if (ios || android)
      EnhanceOpenFLExtension_showOfferwall();
      #end
   }

   // Handle iOS Enhance events

   private static function onEventDispatch(inEvent:Dynamic) : Void {
      var evt = Std.string (Reflect.field (inEvent, "evt"));

      if (evt == "onRewardGranted") {
         var rewardType = Std.string (Reflect.field (inEvent, "rewardType"));
         if (rewardType == "item") {
            if (mOnRewardGranted != null) {
               mOnRewardGranted (REWARD_ITEM, 0);
            }
         }
         else {
            if (mOnRewardGranted != null) {
               mOnRewardGranted (REWARD_COINS, Reflect.field (inEvent, "rewardAmount"));
            }
         }
      }
      else if (evt == "onRewardDeclined") {
         if (mOnRewardDeclined != null) {
            mOnRewardDeclined ();
         }
      }
      else if (evt == "onRewardUnavailable") {
         if (mOnRewardUnavailable != null) {
            mOnRewardUnavailable ();
         }
      }
   }

   // Handle Android Enhance events
   public function onCoinsRewardGranted(response:String): Void {
      if (mOnRewardGranted != null) {
         mOnRewardGranted (REWARD_COINS, Std.parseInt(response));
      }
   }

   public function onItemRewardGranted(response:String): Void {
      if (mOnRewardGranted != null) {
         mOnRewardGranted (REWARD_ITEM, 0);
      }
   }

   public function onRewardDeclined(response:String): Void {
      if (mOnRewardDeclined != null) {
         mOnRewardDeclined ();
      }
   }

   public function onRewardUnavailable(response:String): Void {
      if (mOnRewardUnavailable != null) {
         mOnRewardUnavailable ();
      }
   }

   // JNI mappings for Java functions

   #if (ios)
   private static var EnhanceOpenFLExtension_initialize = Lib.load("enhanceopenflextension", "enhanceopenflextension_initialize", 1);
   private static var EnhanceOpenFLExtension_isInterstitialReady = Lib.load ("enhanceopenflextension", "enhanceopenflextension_isInterstitialReady", 1);
   private static var EnhanceOpenFLExtension_showInterstitialAd = Lib.load ("enhanceopenflextension", "enhanceopenflextension_showInterstitialAd", 1);
   private static var EnhanceOpenFLExtension_isRewardedAdReady = Lib.load ("enhanceopenflextension", "enhanceopenflextension_isRewardedAdReady", 1);
   private static var EnhanceOpenFLExtension_showRewardedAd = Lib.load ("enhanceopenflextension", "enhanceopenflextension_showRewardedAd", 1);
   private static var EnhanceOpenFLExtension_isSpecialOfferReady = Lib.load ("enhanceopenflextension", "enhanceopenflextension_isSpecialOfferReady", 0);
   private static var EnhanceOpenFLExtension_showSpecialOffer = Lib.load ("enhanceopenflextension", "enhanceopenflextension_showSpecialOffer", 0);
   private static var EnhanceOpenFLExtension_isOfferwallReady = Lib.load ("enhanceopenflextension", "enhanceopenflextension_isOfferwallReady", 0);
   private static var EnhanceOpenFLExtension_showOfferwall = Lib.load ("enhanceopenflextension", "enhanceopenflextension_showOfferwall", 0);
   private static var EnhanceOpenFLExtension_logEvent = Lib.load ("enhanceopenflextension", "enhanceopenflextension_logEvent", 3);
   #end

   #if (android)
   private static var EnhanceOpenFLExtension_initialize = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "initialize", "(Lorg/haxe/lime/HaxeObject;)V");
   private static var EnhanceOpenFLExtension_isInterstitialReady = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "isInterstitialReady", "(Ljava/lang/String;)Z");
   private static var EnhanceOpenFLExtension_showInterstitialAd = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "showInterstitialAd", "(Ljava/lang/String;)V");
   private static var EnhanceOpenFLExtension_isRewardedAdReady = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "isRewardedAdReady", "(Ljava/lang/String;)Z");
   private static var EnhanceOpenFLExtension_showRewardedAd = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "showRewardedAd", "(Ljava/lang/String;)V");
   private static var EnhanceOpenFLExtension_isSpecialOfferReady = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "isSpecialOfferReady", "()Z");
   private static var EnhanceOpenFLExtension_showSpecialOffer = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "showSpecialOffer", "()V");
   private static var EnhanceOpenFLExtension_isOfferwallReady = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "isOfferwallReady", "()Z");
   private static var EnhanceOpenFLExtension_showOfferwall = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "showOfferwall", "()V");
   private static var EnhanceOpenFLExtension_logEvent = JNI.createStaticMethod ("org.haxe.extension.EnhanceOpenFLExtension", "logEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
   #end   
}
