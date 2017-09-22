//
//  VideoAdPlayerView.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "VideoAdPlayerView.h"
#import "VideoAdPlayerGoogleIMAMediator.h"

@import AVFoundation;

@interface VideoAdPlayerView()

@property (nonatomic, strong) AVPlayer *contentPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) VideoAdPlayerGoogleIMAMediator *videoAdPlayerGoogleIMAMediator;
//@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation VideoAdPlayerView

// The content URL to play.
static NSString *videoPlaceHolderUrl;

- (instancetype _Nonnull)init {
    if (self = [super init]) {
        if (!videoPlaceHolderUrl) {
            NSString *videoPlaceHolderPath = [[NSBundle mainBundle] pathForResource:@"video-placeholder" ofType:@"mp4"];
            videoPlaceHolderUrl = [NSString stringWithFormat:@"file://%@", videoPlaceHolderPath];
        }
        NSURL *contentURL = [NSURL URLWithString:videoPlaceHolderUrl];
        self.backgroundColor = [UIColor blackColor];
        
        self.contentPlayer = [AVPlayer playerWithURL:contentURL];
        self.contentPlayer.muted = YES;
        
        // Create a player layer for the player.
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];
        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:self.playerLayer];
        
        // Set up our content playhead and contentComplete callback.
        self.videoAdPlayerGoogleIMAMediator = [[VideoAdPlayerGoogleIMAMediator alloc] initWithAdContainerView:self avPlayer:self.contentPlayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.layer.bounds;    
}

- (void)requestAds:(NSString * _Nonnull)adTag {
    self.videoAdPlayerGoogleIMAMediator.adTag = adTag;
    [self.videoAdPlayerGoogleIMAMediator requestAds];
}

- (void)setWebOpenerPresentingController:(UIViewController *)webOpenerPresentingController {
    _webOpenerPresentingController = webOpenerPresentingController;
    self.videoAdPlayerGoogleIMAMediator.webOpenerPresentingController = webOpenerPresentingController;
}

@end
