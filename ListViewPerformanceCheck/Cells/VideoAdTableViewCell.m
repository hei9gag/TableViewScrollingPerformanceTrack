//
//  VideoAdTableViewCell.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "VideoAdTableViewCell.h"

@interface VideoAdTableViewCell()

@property (nonatomic, strong) VideoAdPlayerView *videoAdPlayerView;

@end

@implementation VideoAdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.videoAdPlayerView = [[VideoAdPlayerView alloc] init];
        [self addSubview:self.videoAdPlayerView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoAdPlayerView.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWebOpenPresentingController:(UIViewController *)presentViewController {
    self.videoAdPlayerView.webOpenerPresentingController = presentViewController;
}

@end
