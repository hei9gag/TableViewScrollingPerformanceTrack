//
//  VideoAdPlayerView.h
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

@interface VideoAdPlayerView : UIView

@property(nonatomic, readonly) AVPlayer * _Nonnull contentPlayer;
@property(nonatomic, readonly) IMAAVPlayerContentPlayhead * _Nonnull contentPlayhead;
@property(nonatomic, weak) UIViewController * _Nullable webOpenerPresentingController;

- (instancetype _Nonnull)init;
- (void)requestAds;
- (void)discardAd;

@end
