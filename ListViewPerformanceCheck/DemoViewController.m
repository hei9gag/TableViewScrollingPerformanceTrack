//
//  DemoViewController.m
//  ListViewPerformanceCheck
//
//  Created by hei on 9/21/17.
//  Copyright © 2017 hei. All rights reserved.
//

#import "DemoViewController.h"
#import "VideoAdPlayerView.h"

@interface DemoViewController ()

@property (nonatomic, strong) VideoAdPlayerView *videoPlayerView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Demo AVPlayer";
    self.view.backgroundColor = [UIColor whiteColor];
    self.videoPlayerView = [[VideoAdPlayerView alloc] init];
    self.videoPlayerView.webOpenerPresentingController = self;
    self.videoPlayerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 191);
    [self.view addSubview:self.videoPlayerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
