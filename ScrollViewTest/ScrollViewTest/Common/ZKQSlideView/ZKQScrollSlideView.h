//
//  ZKQScrollSlideView.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/10.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZKQScrollSlideView;

@protocol ZKQScrollSlideViewDelegate <NSObject>

@optional;

- (void)slideView:(ZKQScrollSlideView *)slideView scrollingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(CGFloat)percent;

- (void)slideView:(ZKQScrollSlideView *)slideView didScrolledAtIndex:(NSInteger)index;

@end

@protocol ZKQScrollSlideViewDataSource <NSObject>

- (NSInteger)numberOfControllersInSlideView:(ZKQScrollSlideView *)slideView;

- (UIViewController *)slideView:(ZKQScrollSlideView *)slideView viewControllerAtIndex:(NSInteger)index;

@end

@interface ZKQScrollSlideView : UIView

@property (nonatomic, weak) id <ZKQScrollSlideViewDelegate> delegate;
@property (nonatomic, weak) id <ZKQScrollSlideViewDataSource> dataSource;
@property (nonatomic, weak) UIViewController *baseViewController;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

// 如果要允许左滑返回请将手势传入
@property (nonatomic, weak) UIGestureRecognizer *popGestureRecognizer;

// Default YES
@property (nonatomic, assign) BOOL canScroll;

- (void)scrollTo:(NSInteger)index animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
