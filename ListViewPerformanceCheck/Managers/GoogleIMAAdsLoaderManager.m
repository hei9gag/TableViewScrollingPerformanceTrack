//
//  GoogleIMAAdsLoaderManager.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "GoogleIMAAdsLoaderManager.h"
#import "VideoAdPlayerView.h"

@interface GoogleIMAAdsLoaderManager() <IMAAdsLoaderDelegate, IMAAdsManagerDelegate>

@property(nonatomic, strong) IMAAdsLoader * _Nonnull adsLoader;
@property(nonatomic, strong) IMAAdsManager * _Nullable adsManager;
@property(nonatomic, weak) VideoAdPlayerView * _Nullable adPlayerView;

@end

@implementation GoogleIMAAdsLoaderManager

NSString *const kTestAppAdTagUrl = @"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&"
@"iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&"
@"output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&"
@"correlator=";

+ (GoogleIMAAdsLoaderManager * _Nonnull)sharedManager {
    static GoogleIMAAdsLoaderManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GoogleIMAAdsLoaderManager alloc] init];
        sharedInstance.adsLoader = [[IMAAdsLoader alloc] initWithSettings: nil];
        sharedInstance.adsLoader.delegate = sharedInstance;
    });
    return sharedInstance;
}

- (void)requestAds:(VideoAdPlayerView *)adPlayerView {
    [self resetAdManager];
    
    self.adPlayerView = adPlayerView;
    // Create an ad display container for ad rendering.
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:adPlayerView companionSlots:nil];    
    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:kTestAppAdTagUrl
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:adPlayerView.contentPlayhead
                                                         userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
}

- (void)pauseAd {
    [self.adsManager pause];
}

- (void)stopAd {
}

- (void)resetAdManager {
    if (self.adsManager) {
        [self.adsManager destroy];
    }
    
    if (self.adsLoader) {
        [self.adsLoader contentComplete];
    }
}


#pragma mark AdsLoader Delegates

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    id contextObject = adsLoadedData.userContext;
    if (contextObject) {
        // NSLog(@"contextData: %@", contextData);
    }
    self.adsManager = adsLoadedData.adsManager;
    self.adsManager.volume = 0.0f;
    self.adsManager.delegate = self;

    if (self.adPlayerView) {
        // Create ads rendering settings to tell the SDK to use the in-app browser.
        IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
        adsRenderingSettings.webOpenerPresentingController = self.adPlayerView.webOpenerPresentingController;
        // Initialize the ads manager.
        [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
    }
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    if (self.adPlayerView) {
        [self.adPlayerView.contentPlayer play];
    }
}

#pragma mark AdsManager Delegates

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    if (event.type == kIMAAdEvent_LOADED) {
        [adsManager start];
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    NSLog(@"AdsManager error: %@", error.message);
    if (self.adPlayerView) {
        [self.adPlayerView.contentPlayer play];
    }
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    if (self.adPlayerView) {
        [self.adPlayerView.contentPlayer pause];
    }
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    if (self.adPlayerView) {
        [self.adPlayerView.contentPlayer play];
    }
}

@end
