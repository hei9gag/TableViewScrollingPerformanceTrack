//
//  GoogleIMAAdsLoaderManager.h
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
#import "VideoAdPlayerView.h"

@interface GoogleIMAAdsLoaderManager : NSObject

//@property(nonatomic, readonly) IMAAdsLoader * _Nonnull adsLoader;

+ (GoogleIMAAdsLoaderManager * _Nonnull)sharedManager;
- (void)requestAds:(VideoAdPlayerView * _Nonnull)adPlayerView;
- (void)resetAdManager;

@end
