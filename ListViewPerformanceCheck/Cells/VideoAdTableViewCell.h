//
//  VideoAdTableViewCell.h
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoAdPlayerView.h"

@interface VideoAdTableViewCell : UITableViewCell

@property (nonatomic, readonly) VideoAdPlayerView *videoAdPlayerView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setWebOpenPresentingController:(UIViewController *)presentViewController;

@end
