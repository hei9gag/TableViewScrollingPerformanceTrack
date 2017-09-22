//
//  VideoAdPlayerMediator.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/22/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "VideoAdPlayerGoogleIMAMediator.h"
#import "GoogleIMAAdsLoaderManager.h"

@interface VideoAdPlayerGoogleIMAMediator() 

@property (nonatomic, strong) IMAAVPlayerContentPlayhead * _Nonnull contentPlayhead;
@property (nonatomic, weak) AVPlayer * _Nullable avPlayer;
@property (nonatomic, weak) UIView * _Nullable adContainerView;
@property (nonatomic, weak) UIView * _Nullable imaAdView;

@end

@implementation VideoAdPlayerGoogleIMAMediator

- (instancetype _Nonnull)initWithAdContainerView:(UIView * _Nonnull)adContainerView avPlayer:(AVPlayer * _Nonnull)avPlayer {
    if (self = [super init]) {
        self.avPlayer = avPlayer;
        self.adContainerView = adContainerView;
        self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:avPlayer];
    }
    return self;
}

- (void)requestAds {
    [[GoogleIMAAdsLoaderManager sharedManager] requestAds:self];
}

#pragma mark AdsManager Delegates
// TODO: Poprgate call back event to VideoAdPlayerView
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
    if (self.avPlayer) {
        [self.avPlayer play];
    }
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    if (self.avPlayer) {
        [self.avPlayer play];
    }
}


@end
