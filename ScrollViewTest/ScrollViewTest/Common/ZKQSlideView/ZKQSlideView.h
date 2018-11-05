//
//  ZKQSlideView.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/5.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZKQSlideView;

@protocol ZKQSlideViewDelegate <NSObject>

- (void)slideView:(ZKQSlideView *)slideView scrollingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(CGFloat)percent;

- (void)slideView:(ZKQSlideView *)slideView didScrolledViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

- (void)slideView:(ZKQSlideView *)slideView scrollCanceled:(NSInteger)fromIndex;

@end

@protocol ZKQSlideViewDataSource <NSObject>

- (NSInteger)numberOfControllersInSlideView:(ZKQSlideView *)slideView;

- (UIViewController *)slideView:(ZKQSlideView *)slideView viewControllerAtIndex:(NSInteger)index;

@end

@interface ZKQSlideView : UIView

@property (nonatomic, weak) id <ZKQSlideViewDelegate> delegate;
@property (nonatomic, weak) id <ZKQSlideViewDataSource> dataSource;
@property (nonatomic, weak) UIViewController *baseViewController;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isScrolling;

// Default YES
@property (nonatomic, assign) BOOL canScroll;

- (void)switchTo:(NSInteger)index animation:(BOOL)animation;


@end

NS_ASSUME_NONNULL_END
