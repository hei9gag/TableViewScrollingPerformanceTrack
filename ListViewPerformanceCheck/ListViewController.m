//
//  ListViewController.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/6/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "ListViewController.h"
#import "FBAnimationPerformanceTracker.h"
#import "VideoAdTableViewCell.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FBAnimationPerformanceTrackerDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) FBAnimationPerformanceTracker *performanceTracker;
@property (nonatomic, readwrite) NSUInteger currentRepeatTime;
@property (nonatomic, readwrite) NSUInteger repeatTime;
@property (nonatomic, readwrite) CGFloat delayToStart;
@property (nonatomic, readwrite) NSUInteger scrollOffSet;
@property (nonatomic, readwrite) CGFloat delayBetween;
@property (nonatomic, readwrite) BOOL isTracking;

@end

@implementation ListViewController

static NSString *kSimpleTableIdentifier = @"SimpleTableItem";
static NSString *kVideoAdCellIdentifier = @"VideoAdCellIdentifier";
NSString *const kTestAppAdTagUrl = @"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&"
@"iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&"
@"output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&"
@"correlator=";

NSString *const kSpotXAdTag = @"https://pubads.g.doubleclick.net/gampad/ads?sz=400x300&iu=/16921351/testingvideo&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=[timestamp]";

+ (CGFloat)postHeight {
    return 250;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:kSimpleTableIdentifier];
    [self.tableview registerClass:[VideoAdTableViewCell class] forCellReuseIdentifier:kVideoAdCellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Begin Test" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemTap:)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    FBAnimationPerformanceTrackerConfig config = {
        .smallDropEventFrameNumber = 1,
        .largeDropEventFrameNumber = 4,
        .maxFrameDropAccount = 15,
        .reportStackTraces = NO,
    };
    
    self.performanceTracker = [[FBAnimationPerformanceTracker alloc] initWithConfig:config];
    self.performanceTracker.delegate = self;
    
    self.currentRepeatTime = 0;
    self.repeatTime = 10;
    self.delayToStart = 1;
    self.scrollOffSet = [self.class postHeight] * 4;
    self.delayBetween = 0.5;
    self.isTracking = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!scrollView.dragging && self.isTracking) {
        if (self.currentRepeatTime > self.repeatTime) {
            self.isTracking = NO;
            [self.performanceTracker stop];
            self.rightItem.enabled = YES;
            self.currentRepeatTime = 0;
            return;
        }
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayBetween * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.currentRepeatTime += 1;
            [scrollView setContentOffset:CGPointMake(0,scrollView.contentOffset.y + self.scrollOffSet) animated:YES];
        });
    }
}

#pragma mark - FBAnimationPerformanceTrackerDelegate
- (void)reportDurationInMS:(NSInteger)duration smallDropEvent:(double)smallDropEvent largeDropEvent:(double)largeDropEvent {
    double numberOfFrameDropped = smallDropEvent;
    CGFloat frameDropPerSecond = numberOfFrameDropped/((CGFloat)(duration/1000.0));
    CGFloat framePerSecond = 60-frameDropPerSecond;
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSLog(@"PROFILING_IOS.SCROLLING_FPS TIMESTAMP=%lld FPS=%f", milliseconds, framePerSecond);
}

- (void)reportStackTrace:(NSString *)stack withSlide:(NSString *)slide {
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"[ListView] cellForRowAtIndexPath:%zd", indexPath.row);
    if ([self isAdIndex:indexPath]) {
        VideoAdTableViewCell *videoAdCell = [tableView dequeueReusableCellWithIdentifier:kVideoAdCellIdentifier forIndexPath:indexPath];
        [videoAdCell setWebOpenPresentingController:self];
        [videoAdCell.videoAdPlayerView requestAds:kTestAppAdTagUrl];
        return videoAdCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSimpleTableIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"[ListView] willDisplayCell:%zd", indexPath.row);
    if ([self isAdIndex:indexPath] && [cell isKindOfClass:[VideoAdTableViewCell class]]) {
        // VideoAdTableViewCell *videoAdCell = (VideoAdTableViewCell *)cell;
    } else {
        NSString *title = [NSString stringWithFormat:@"Post %zd", indexPath.row + 1];
        cell.textLabel.text = title;
    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.class postHeight];
}


- (BOOL)isAdIndex:(NSIndexPath *)indexPath {
    NSUInteger rowIndex = indexPath.row + 1;
    return rowIndex % 10 == 0;
}

#pragma mark - Private
- (void)rightBarItemTap:(id)sender {
    self.rightItem.enabled = NO;
    [self scrollPerformanceTrack];
}

- (void)scrollPerformanceTrack {
    __weak typeof(self) weakSelf = self;
    [self.tableview setContentOffset:CGPointZero animated:NO];
    if (self.currentRepeatTime == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayToStart * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.currentRepeatTime += 1;
            weakSelf.isTracking = YES;
            [weakSelf.performanceTracker start];
            UIScrollView *scrollView = weakSelf.tableview;
            [scrollView setContentOffset:CGPointMake(0,scrollView.contentOffset.y + weakSelf.scrollOffSet) animated:YES];
        });
    }
}


@end
