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
#import "ZKQSlideTabBarView.h"

#import <UINavigationController+FDFullscreenPopGesture.h>

@interface TabBarSlideViewController () <ZKQSlideViewDelegate, ZKQSlideViewDataSource, ZKQSlideTabbarDelegate>

@property (nonatomic, weak) ZKQSlideView *slideView;

@property (nonatomic, strong) ZKQMemoryCache *cache;

@property (nonatomic, weak) ZKQSlideTabBarView *slideTabBarView;

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
    
    [self.view bringSubviewToFront:self.slideTabBarView];
    
    CGFloat tabBarHight = 40;
    CGFloat top = 0;
    if (@available(iOS 11.0, *)) {
        top = self.view.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
        top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    self.slideTabBarView.frame = CGRectMake(0, top, self.view.bounds.size.width, tabBarHight);
    
    self.slideView.frame = CGRectMake(0, self.slideTabBarView.frame.origin.y + self.slideTabBarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.slideTabBarView.frame.origin.y - self.slideTabBarView.bounds.size.height);
}

- (void)_commonUI {
    
    ZKQSlideTabBarView *slideTabBarView = [[ZKQSlideTabBarView alloc] init];
    slideTabBarView.delegate = self;
    slideTabBarView.trackColor = [UIColor colorWithRGB:0xcc0000];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        ZKQSlideTabBarViewItem *item = [ZKQSlideTabBarViewItem commonItem];
        item.title = [NSString stringWithFormat:@"第%zd个", i];
        [array addObject:item];
    }
    
    [slideTabBarView buildTabBarItems:array];
    
    [self.view addSubview:slideTabBarView];
    self.slideTabBarView = slideTabBarView;
    
    
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

#pragma mark - ZKQSlideView

- (NSInteger)numberOfControllersInSlideView:(ZKQSlideView *)slideView {
    return 4;
}

- (UIViewController *)slideView:(ZKQSlideView *)slideView viewControllerAtIndex:(NSInteger)index {
    
    NSString *key = [NSString stringWithFormat:@"%zd", index];
    
    UIViewController *con = [self.cache objectForKey:key];
    
    if (con) {
        return con;
    }
    
    TestTableViewController *message = [[TestTableViewController alloc] init];
    
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
    [self.slideTabBarView scrollingTo:toIndex percent:percent];
}

- (void)slideView:(ZKQSlideView *)slideView didScrolledViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self.slideTabBarView scrollDidIndex:index];
}

- (void)slideView:(ZKQSlideView *)slideView scrollCanceled:(NSInteger)fromIndex {
    
}

- (BOOL)slideTabBarCanSelect:(id)sender {
    if (self.slideView.isScrolling) {
        return NO;
    } else {
        return YES;
    }
}

- (void)slideTabBar:(id)sender selectAt:(NSInteger)index {
    [self.slideView scrollTo:index animation:YES];
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
