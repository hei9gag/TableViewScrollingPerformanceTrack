//
//  GoogleIMAAdsLoaderManager.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "GoogleIMAAdsLoaderManager.h"


@interface GoogleIMAAdsLoaderManager() <IMAAdsLoaderDelegate>

@property(nonatomic, strong) IMAAdsLoader * _Nonnull adsLoader;
@property(nonatomic, strong) IMAAdsManager * _Nullable adsManager;
@property(nonatomic, weak) VideoAdPlayerGoogleIMAMediator * _Nullable mediator;

@end

@implementation GoogleIMAAdsLoaderManager

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

- (void)requestAds:(VideoAdPlayerGoogleIMAMediator * _Nonnull)mediator {
    if (!mediator.adTag || !mediator.adContainerView || !mediator.contentPlayhead) {
        return;
    }
    
    [self resetAdManager];
    //self.adPlayerView = adPlayerView;
    // Create an ad display container for ad rendering.
    self.mediator = mediator;
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:mediator.adContainerView companionSlots:nil];
    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:mediator.adTag
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:mediator.contentPlayhead
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
    self.adsManager = adsLoadedData.adsManager;
    self.adsManager.volume = 0.0f;
    if (self.mediator) {
        IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
        adsRenderingSettings.disableUi = YES;
        adsRenderingSettings.webOpenerPresentingController = self.mediator.webOpenerPresentingController;
        // Initialize the ads manager.
        [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
        self.adsManager.delegate = self.mediator;
    }
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    // TODO handle failure case
//    if (self.adPlayerView) {
//        [self.adPlayerView.contentPlayer play];
//    }
}

@end
