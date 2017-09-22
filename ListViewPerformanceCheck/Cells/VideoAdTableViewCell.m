//
//  VideoAdTableViewCell.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "VideoAdTableViewCell.h"

@interface VideoAdTableViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) VideoAdPlayerView *videoAdPlayerView;
//@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readwrite) CGPoint previousPanPoint;

@end

@implementation VideoAdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.videoAdPlayerView = [[VideoAdPlayerView alloc] init];        
        [self addSubview:self.videoAdPlayerView];
//        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
//        self.panGestureRecognizer.delegate = self;
//        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoAdPlayerView.frame = self.bounds;
    if (!self.tableView) {
        UIView *superView = self.superview;
        while (superView) {
            if ([superView isKindOfClass:[UITableView class]]) {
                self.tableView = (UITableView *)self.superview;
            }
            superView = superView.superview;
        }
    }
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

/*
-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (!self.tableView) {
        return;
    }
    
    CGPoint translatePoint = [panGestureRecognizer locationInView:self];
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    
    NSLog(@"translatePoint x:%f y:%f", translatePoint.x, translatePoint.y);
    NSLog(@"velocity x:%f y:%f", velocity.x, velocity.y);
    
    if (translatePoint.y < 0 || translatePoint.y > self.bounds.size.height) {
        return;
    }
    
    if (velocity.y > - 25 && velocity.y < 50) {
        return;
    }
    
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        self.previousPanPoint = translatePoint;
        //self.tableView.scrollEnabled = NO;
    } else if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        CGFloat diff = translatePoint.y - self.previousPanPoint.y + (-velocity.y);
        CGFloat newContentOffSetY = self.tableView.contentOffset.y + diff;
        [self.tableView setContentOffset:CGPointMake(0, newContentOffSetY) animated:YES];
        
//        CGFloat newContentOffSetY = self.tableView.contentOffset.y + newY;
//
//        [self.tableView scrollRectToVisible:CGRectMake(0, newContentOffSetY, self.tableView.frame.size.width, self.tableView.frame.size.height) animated:YES];
        //self.tableView.contentOffset = CGPointMake(0, contentOffSetY + newY);
        self.previousPanPoint = translatePoint;
    } else if (state == UIGestureRecognizerStateEnded) {
        //self.tableView.scrollEnabled = YES;
    }
}

// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // NSLog(@"gestureRecognizer: %@ otherGestureRecognizer: %@", gestureRecognizer, otherGestureRecognizer);
    return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}*/

@end
