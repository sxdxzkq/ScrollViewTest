//
//  TabBarSlideViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/6.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "TabBarSlideViewController.h"
#import "TestTableViewController.h"

#import "ZKQSlideView.h"
#import "ZKQMemoryCache.h"

#import <UINavigationController+FDFullscreenPopGesture.h>

@interface TabBarSlideViewController () <ZKQSlideViewDelegate, ZKQSlideViewDataSource>

@property (nonatomic, weak) ZKQSlideView *slideView;

@property (nonatomic, strong) ZKQMemoryCache *cache;

@end

@implementation TabBarSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _commonUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.slideView.frame = self.view.bounds;
}

- (void)_commonUI {
    ZKQSlideView *slideView = [[ZKQSlideView alloc] init];
    slideView.delegate = self;
    slideView.dataSource = self;
    slideView.baseViewController = self;
    slideView.popGestureRecognizer = self.navigationController.fd_fullscreenPopGestureRecognizer;
    [self.view addSubview:slideView];
    self.slideView = slideView;
    
    self.cache = [[ZKQMemoryCache alloc] initWithCacheCount:4];
    
    [self.slideView build];
}

- (NSInteger)numberOfControllersInSlideView:(ZKQSlideView *)slideView {
    return 4;
}

- (UIViewController *)slideView:(ZKQSlideView *)slideView viewControllerAtIndex:(NSInteger)index {
    
    NSString *key = [NSString stringWithFormat:@"%zd", index];
    
    UIViewController *con = [self.cache objectForKey:key];
    
    if (con) {
        return con;
    }
    
    UIViewController *message = [[UIViewController alloc] init];
    
    UIColor *color;
    
    switch (index) {
        case 0:
            color = [UIColor orangeColor];
            break;
        case 1:
            color = [UIColor blueColor];
            break;
        case 2:
            color = [UIColor greenColor];
            break;
        case 3:
            color = [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    message.view.backgroundColor = color;
    return message;
    
}

- (void)slideView:(ZKQSlideView *)slideView scrollingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(CGFloat)percent {
    
}

- (void)slideView:(ZKQSlideView *)slideView didScrolledViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    
}

- (void)slideView:(ZKQSlideView *)slideView scrollCanceled:(NSInteger)fromIndex {
    
}

#pragma mark - ZKQSlideView

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
