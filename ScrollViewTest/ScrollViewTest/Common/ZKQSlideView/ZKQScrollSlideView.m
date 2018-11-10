//
//  ZKQScrollSlideView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/10.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQScrollSlideView.h"

@interface ZKQScrollSlideView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger scrollToIndex;
@property (nonatomic, assign) CGPoint panStartPoint;

@end

@implementation ZKQScrollSlideView

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
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
}

#pragma mark - Private
- (void)_commonInit {
    
    self.canScroll = YES;
    self.scrollToIndex = -1;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeZero;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    collectionView.alwaysBounceVertical = NO;
    collectionView.alwaysBounceHorizontal = NO;
    collectionView.panGestureRecognizer.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 关闭自动空出NavigationBar
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Public
- (void)scrollTo:(NSInteger)index animation:(BOOL)animation {
    self.scrollToIndex = index;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animation];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfControllersInSlideView:)]) {
        return [self.dataSource numberOfControllersInSlideView:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.scrollToIndex > 0 && cell.tag != self.scrollToIndex) {
        return;
    }
    
    UIViewController *vc = [self.dataSource slideView:self viewControllerAtIndex:indexPath.row];
    [self.baseViewController addChildViewController:vc];
    vc.view.frame = self.bounds;
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self.baseViewController];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
        [self.delegate slideView:self didScrolledViewController:vc atIndex:indexPath.row];
    }
    
    if (self.scrollToIndex == cell.tag) self.scrollToIndex = -1;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *controllerView = cell.contentView.subviews.firstObject;
    
    if (controllerView) {
        UIViewController *con;
        for (UIViewController *childCon in self.baseViewController.childViewControllers) {
            if (childCon.view == controllerView) {
                con = childCon;
                break;
            }
        }
        if (con) {
            [con willMoveToParentViewController:nil];
            [con.view removeFromSuperview];
            [con removeFromParentViewController];
            
            [con endAppearanceTransition];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    CGPoint point = [pan translationInView:scrollView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = point;
    }
    
    if (self.scrollToIndex < 0) {
        
        if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            self.oldIndex = self.currentIndex;
        } else if (scrollView.tracking || scrollView.dragging || scrollView.decelerating) {
            if ([self.delegate respondsToSelector:@selector(slideView:scrollingFrom:to:percent:)]) {
                [self.delegate slideView:self scrollingFrom:self.currentIndex to:<#(NSInteger)#> percent:<#(CGFloat)#>]
            }
        }
        
        if (self.oldIndex != self.currentIndex) {
            self.oldIndex = self.currentIndex;
        }
    }
}

#pragma mark - UIGestureRecognizerDelagate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.currentIndex == 0 && self.popGestureRecognizer == otherGestureRecognizer) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - setter && getter
- (NSInteger)currentIndex {
    
    NSInteger index = self.collectionView.contentOffset.x / self.bounds.size.width;
    
    return index;
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    self.collectionView.scrollEnabled = canScroll;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
