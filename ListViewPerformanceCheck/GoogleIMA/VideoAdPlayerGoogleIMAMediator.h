//
//  VideoAdPlayerMediator.h
//  ListViewPerformanceCheck
//
//  Created by hei on 9/22/17.
//  Copyright © 2017 hei. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

@interface VideoAdPlayerGoogleIMAMediator : NSObject <IMAAdsManagerDelegate>

@property (nonatomic, readonly) IMAAVPlayerContentPlayhead * _Nonnull contentPlayhead;
@property (nonatomic, weak, readonly) AVPlayer * _Nullable avPlayer;
@property (nonatomic, weak, readonly) UIView * _Nullable adContainerView;
@property (nonatomic, weak) UIViewController * _Nullable webOpenerPresentingController;
@property (nonatomic, copy) NSString * _Nullable adTag;

- (instancetype _Nonnull)initWithAdContainerView:(UIView * _Nonnull)adContainerView avPlayer:(AVPlayer * _Nonnull)avPlayer;
- (void)requestAds;

@end
