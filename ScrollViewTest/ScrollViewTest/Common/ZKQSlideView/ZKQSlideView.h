//
//  ZKQSlideView.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/5.
//  Copyright © 2018 zkq. All rights reserved.
//

/*
 感谢DLSlideView作者 github: https://github.com/agdsdl/DLSlideView
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZKQSlideView;

@protocol ZKQSlideViewDelegate <NSObject>

@optional;

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

// 如果要允许左滑返回请将手势传入
@property (nonatomic, weak) UIGestureRecognizer *popGestureRecognizer;

// Default YES
@property (nonatomic, assign) BOOL canScroll;


- (void)build;
- (void)scrollTo:(NSInteger)index animation:(BOOL)animation;


@end

NS_ASSUME_NONNULL_END
