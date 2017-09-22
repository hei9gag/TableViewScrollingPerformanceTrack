//
//  VideoAdPlayerView.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "VideoAdPlayerView.h"
#import "GoogleIMAAdsLoaderManager.h"

@import AVFoundation;

@interface VideoAdPlayerView()

/// Content video player.
@property(nonatomic, strong) AVPlayer *contentPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;

@end

@implementation VideoAdPlayerView

// The content URL to play.
NSString *const kTestVideoUrl = @"http://rmcdn.2mdn.net/Demo/html5/output.mp4";
static NSString *videoPlaceHolderUrl;

- (instancetype _Nonnull)init {
    if (self = [super init]) {
        if (!videoPlaceHolderUrl) {
            NSString *videoPlaceHolderPath = [[NSBundle mainBundle] pathForResource:@"video-placeholder" ofType:@"mp4"];
            videoPlaceHolderUrl = [NSString stringWithFormat:@"file://%@", videoPlaceHolderPath];
        }
        NSURL *contentURL = [NSURL URLWithString:videoPlaceHolderUrl];
        self.backgroundColor = [UIColor blackColor];
        //NSURL *contentURL = [NSURL URLWithString:kTestVideoUrl];
        
        //self.contentPlayer = [AVPlayer playerWithURL:contentURL];
        self.contentPlayer = [AVPlayer playerWithURL:contentURL];
        self.contentPlayer.muted = YES;
        
        // Create a player layer for the player.
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];
        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:self.playerLayer];
        
        // Set up our content playhead and contentComplete callback.
        self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];                
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.layer.bounds;    
}

- (void)requestAds {
    [[GoogleIMAAdsLoaderManager sharedManager] requestAds:self];
}

- (void)pauseAd {
    
}

- (void)discardAd {
    [[GoogleIMAAdsLoaderManager sharedManager] resetAdManager];
}


@end
