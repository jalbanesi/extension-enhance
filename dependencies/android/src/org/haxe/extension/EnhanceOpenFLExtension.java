package org.haxe.extension;


import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.util.Log;

import org.haxe.lime.HaxeObject;
import com.fgl.enhance.connector.FglEnhance;

// OpenFL extension

public class EnhanceOpenFLExtension extends Extension {
   // Tag for logging
	static final String TAG = "FGLSDK::EnhanceOpenFLExtension";
   
	// Version
	static final String CONNECTOR_VERSION = "2.2.0";

   // Object for calling back into Haxe code
   static HaxeObject m_haxeObject;

   // Lifecycle management

	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
      Log.d (TAG, "onCreate");
		FglEnhance.initialize (Extension.mainActivity);
	}
		
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
      Log.d (TAG, "onDestroy");
	}
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
      Log.d (TAG, "onPause");
	}
		
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
      Log.d (TAG, "onRestart");
	}
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
      Log.d (TAG, "onResume");
	}
		
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
      Log.d (TAG, "onStart");
	}
		
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
      Log.d (TAG, "onStop");
	}
	
	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {		
      Log.d (TAG, "onActivityResult");
		return true;		
	}

   // Initialize

   public static void initialize (final HaxeObject haxeObject) {
      m_haxeObject = haxeObject;
      Log.d (TAG, "initialize version " + CONNECTOR_VERSION);
   }

   static public boolean isInterstitialReady(String strPlacementType) {
      return FglEnhance.isInterstitialReady(strPlacementType.toLowerCase());
   }

   static public void showInterstitialAd (String strPlacementType) {
      FglEnhance.showInterstitialAd(strPlacementType.toLowerCase());
   }
   
   static public boolean isRewardedAdReady(String strPlacementType) {
      return FglEnhance.isRewardedAdReady(strPlacementType.toUpperCase());
   }

   static public void showRewardedAd (String strPlacementType) {
      Log.d (TAG, "showRewardedAd with placement " + strPlacementType);
      
      FglEnhance.showRewardedAd (new FglEnhance.RewardCallback() {
		      @Override
		      public void onRewardGranted(final int rewardValue, FglEnhance.RewardType rewardType) {
				   // Reward granted
				   Log.i (TAG, "onRewardGranted");
				   if (rewardType == FglEnhance.RewardType.COINS) {
                  Extension.callbackHandler.post(new Runnable() { 
                     public void run() {
                        if (m_haxeObject != null)
                           m_haxeObject.call("onCoinsRewardGranted", new Object[] {Integer.toString(rewardValue)});
                     }
                  });
               }
				   else {
                  Extension.callbackHandler.post(new Runnable() { 
                     public void run() {
                        if (m_haxeObject != null)
                           m_haxeObject.call("onItemRewardGranted", new Object[] {""});
                     }
                  });
               }
		      }
		            
		      @Override
		      public void onRewardDeclined() {		            	
				   // Reward declined
				   Log.i (TAG, "onRewardDeclined");
               Extension.callbackHandler.post(new Runnable() { 
                  public void run() {
                     if (m_haxeObject != null)
                        m_haxeObject.call("onRewardDeclined", new Object[] {""});
                  }
               });
		      }
		            
		      @Override
		      public void onRewardUnavailable() {		            	
				   // Reward unavailable
				   Log.i (TAG, "onRewardUnavailable");
               Extension.callbackHandler.post(new Runnable() { 
                  public void run() {
                     if (m_haxeObject != null)
                        m_haxeObject.call("onRewardUnavailable", new Object[] {""});
                  }
               });
		      }
		}, strPlacementType.toUpperCase());
   }

   static public boolean isSpecialOfferReady() {
      return FglEnhance.isSpecialOfferReady();
   }
   
   static public void showSpecialOffer () {
      FglEnhance.showSpecialOffer();
   }
   
   static public boolean isOfferwallReady() {
      return FglEnhance.isOfferwallReady();
   }
   
   static public void showOfferwall () {
      FglEnhance.showOfferwall();
   }
   
   static public void logEvent (String eventType, String paramKey, String paramValue) {
      if (paramKey != null && paramKey.length() != 0)
         Log.d (TAG, "logEvent with eventType '" + eventType + "' and paramKey '" + paramKey + "', paramValue '" + paramValue + "'");
      else
         Log.d (TAG, "logEvent with eventType " + eventType);
      FglEnhance.logEvent(eventType, paramKey, paramValue);
   }
}
