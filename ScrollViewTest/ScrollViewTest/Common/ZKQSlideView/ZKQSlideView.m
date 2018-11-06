//
//  ZKQSlideView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/5.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQSlideView.h"

const CGFloat kPanScrollOffsetThreshold = 50.0f;

@interface ZKQSlideView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger oldIndex;
@property (nonatomic, assign) NSInteger futureIndex;

// 手动做内存管理
@property (nonatomic, strong) UIViewController *oldViewController;
@property (nonatomic, strong) UIViewController *futureViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint panStartPoint;

@end

@implementation ZKQSlideView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _commonInit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.oldViewController.view.frame = self.bounds;
}

#pragma mark - Private
- (void)_commonInit {
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    self.pan.delegate = self;
    self.canScroll = YES;
    self.oldIndex = -1;
    self.futureIndex = -1;
}

- (void)removeOld {
    [self removeViewController:self.oldViewController];
    [self.oldViewController endAppearanceTransition];
    self.oldViewController = nil;
    self.oldIndex = -1;
}

- (void)removeFuture {
    [self.futureViewController beginAppearanceTransition:NO animated:NO];
    [self removeViewController:self.futureViewController];
    [self.futureViewController endAppearanceTransition];
    self.futureViewController = nil;
    self.futureIndex = -1;
}

- (void)removeViewController:(UIViewController *)viewController{
    UIViewController *vc = viewController;
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)showAt:(NSInteger)index{
    if (self.oldIndex == index) {
        return;
    }
    
    [self removeOld];
    
    UIViewController *vc = [self.dataSource slideView:self viewControllerAtIndex:index];
    [self.baseViewController addChildViewController:vc];
    vc.view.frame = self.bounds;
    [self addSubview:vc.view];
    [vc didMoveToParentViewController:self.baseViewController];
    self.oldIndex = index;
    self.oldViewController = vc;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
        [self.delegate slideView:self didScrolledViewController:vc atIndex:index];
    }
    self.futureViewController = nil;
    self.futureIndex = -1;
}

- (void)showAtAnimation:(NSInteger)index{
    if (index == self.oldIndex || self.isScrolling) {
        return;
    }
    
    self.futureIndex = index;
    
    if (self.oldViewController && self.oldViewController.parentViewController == self.baseViewController) {
        self.isScrolling = YES;

        UIViewController *oldViewController = self.oldViewController;
        UIViewController *newViewController = [self.dataSource slideView:self viewControllerAtIndex:index];
        
        [oldViewController willMoveToParentViewController:nil];
        [self.baseViewController addChildViewController:newViewController];
        
        CGRect nowRect = CGRectMake(CGRectGetMinX(oldViewController.view.frame), CGRectGetMinY(oldViewController.view.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGRect leftRect = CGRectMake(nowRect.origin.x-nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);
        CGRect rightRect = CGRectMake(nowRect.origin.x+nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);
        
        CGRect newStartRect;
        CGRect oldEndRect;
        
        if (index > self.oldIndex) {
            newStartRect = rightRect;
            oldEndRect = leftRect;
        }
        else{
            newStartRect = leftRect;
            oldEndRect = rightRect;
        }
        
        newViewController.view.frame = newStartRect;
        [newViewController willMoveToParentViewController:self.baseViewController];
        
        [self.baseViewController transitionFromViewController:oldViewController toViewController:newViewController duration:0.4 options:0 animations:^{
            newViewController.view.frame = nowRect;
            oldViewController.view.frame = oldEndRect;
        } completion:^(BOOL finished) {
            [oldViewController removeFromParentViewController];
            [newViewController didMoveToParentViewController:self.baseViewController];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
                [self.delegate slideView:self didScrolledViewController:newViewController atIndex:index];
            }
            
            self.isScrolling = NO;
        }];
        
        self.oldIndex = index;
        self.oldViewController = newViewController;
    }
    else{
        [self showAt:index];
        self.isScrolling = NO;
    }
    
    self.futureViewController = nil;
    self.futureIndex = -1;
}

- (void)repositionForOffsetX:(CGFloat)offsetx{
    CGFloat x = 0.0f;
    
    CGFloat maxOffsetx = 0.0f;
    
    if (self.futureIndex < self.oldIndex) {
        x = self.bounds.origin.x - self.bounds.size.width + MIN(offsetx, self.bounds.size.width);
        maxOffsetx = MIN(offsetx, self.bounds.size.width);
    } else if (self.futureIndex > self.oldIndex){
        x = self.bounds.origin.x + self.bounds.size.width + MAX(offsetx, -self.bounds.size.width);
        maxOffsetx = MAX(offsetx, -self.bounds.size.width);
    }
    
    UIViewController *oldvc = self.oldViewController;
    oldvc.view.frame = CGRectMake(self.bounds.origin.x + maxOffsetx, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    if (self.futureIndex >= 0 && self.futureIndex < [self.dataSource numberOfControllersInSlideView:self]) {
        UIViewController *vc = self.futureViewController;
        vc.view.frame = CGRectMake(x, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:scrollingFrom:to:percent:)]) {
        [self.delegate slideView:self scrollingFrom:self.oldIndex to:self.futureIndex percent:fabs(offsetx)/self.bounds.size.width];
    }
}

- (void)backToOldWithOffset:(CGFloat)offsetx {
    NSTimeInterval animatedTime = 0;
    animatedTime = 0.3;
    
    //animatedTime = fabs(self.frame.size.width - fabs(offsetx)) / self.frame.size.width * 0.35;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self repositionForOffsetX:0];
    } completion:^(BOOL finished) {
        if (self.futureIndex >= 0 && self.futureIndex < [self.dataSource numberOfControllersInSlideView:self] && self.futureIndex != self.oldIndex) {
            //[self removeAt:panToIndex_];
            [self.oldViewController beginAppearanceTransition:YES animated:NO];
            [self removeFuture];
            [self.oldViewController endAppearanceTransition];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:scrollCanceled:)]) {
            [self.delegate slideView:self scrollCanceled:self.oldIndex];
        }
    }];
    
}

#pragma mark - public
- (void)switchTo:(NSInteger)index animation:(BOOL)animation {
    if (animation) {
        [self showAtAnimation:index];
    } else {
        [self showAt:index];
    }
}

- (void)build {
    [self showAt:0];
}

#pragma mark - action
- (void)panHandler:(UIPanGestureRecognizer *)pan {
    if (self.oldIndex < 0 || self.isScrolling) {
        return;
    }
    
    CGPoint point = [pan translationInView:self];
   
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = point;
        [self.oldViewController beginAppearanceTransition:NO animated:YES];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat offsetx = point.x - self.panStartPoint.x;
        
        NSInteger panToIndex = -1;
        
        if (offsetx > 0) {
            panToIndex = self.oldIndex - 1;
        }
        else if(offsetx < 0){
            panToIndex = self.oldIndex + 1;
        }
        
        if (panToIndex != self.futureIndex) {
            if (self.futureViewController) {
                [self removeFuture];
            }
        }
        
        if (panToIndex < 0 || panToIndex >= [self.dataSource numberOfControllersInSlideView:self]) {
            // 处理极限值
//            self.futureIndex = panToIndex;
//            [self repositionForOffsetX:offsetx/2.0f];
        } else {
            if (panToIndex != self.futureIndex) {
                //fix bug #5
                //                if (willCtrl_) {
                //                    [self removeWill];
                //                }
                self.futureViewController = [self.dataSource slideView:self viewControllerAtIndex:panToIndex];
                [self.baseViewController addChildViewController:self.futureViewController];
                
                [self.futureViewController willMoveToParentViewController:self.baseViewController];
                [self.futureViewController beginAppearanceTransition:YES animated:YES];
                [self addSubview:self.futureViewController.view];
                
                self.futureIndex = panToIndex;
            }
            [self repositionForOffsetX:offsetx];
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetx = point.x - self.panStartPoint.x;
        if (self.futureIndex >= 0 && self.futureIndex < [self.dataSource numberOfControllersInSlideView:self] && self.futureIndex != self.oldIndex) {
            if (fabs(offsetx) > kPanScrollOffsetThreshold) {
                NSTimeInterval animatedTime = 0;
                animatedTime = fabs(self.frame.size.width - fabs(offsetx)) / self.frame.size.width * 0.4;
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView animateWithDuration:animatedTime animations:^{
                    [self repositionForOffsetX:offsetx > 0 ? self.bounds.size.width : -self.bounds.size.width];
                } completion:^(BOOL finished) {
                    //[self removeAt:oldIndex_];
                    [self removeOld];
                    
                    if (self.futureIndex >= 0 && self.futureIndex < [self.dataSource numberOfControllersInSlideView:self]) {
                        [self.futureViewController endAppearanceTransition];
                        [self.futureViewController didMoveToParentViewController:self.baseViewController];
                        self.oldIndex = self.futureIndex;
                        self.oldViewController = self.futureViewController;
                        self.futureViewController = nil;
                        self.futureIndex = -1;
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
                        [self.delegate slideView:self didScrolledViewController:self.oldViewController atIndex:self.oldIndex];
                    }
                }];
            }
            else{
                [self backToOldWithOffset:offsetx];
                self.panStartPoint = CGPointZero;
            }
        }
        else{
            [self backToOldWithOffset:offsetx];
            self.panStartPoint = CGPointZero;
        }
    } else{
        CGFloat offsetx = point.x - self.panStartPoint.x;
        [self backToOldWithOffset:offsetx];
        self.panStartPoint = CGPointZero;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.oldIndex == 0 && self.popGestureRecognizer == otherGestureRecognizer) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - setter && getter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex != self.oldIndex) {
        [self switchTo:selectedIndex animation:NO];
    }
}

- (NSInteger)selectedIndex{
    return self.oldIndex;
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (canScroll) {
        if (![[self gestureRecognizers] containsObject:self.pan]) {
            [self addGestureRecognizer:self.pan];
        }
    } else {
        [self removeGestureRecognizer:self.pan];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
