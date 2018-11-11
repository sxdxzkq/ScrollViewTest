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
@property (nonatomic, assign) NSInteger oldIndex;

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

- (void)dealloc {
    
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
//    collectionView.panGestureRecognizer.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    //kvo
    [collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
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
    [vc willMoveToParentViewController:self.baseViewController];
    [vc beginAppearanceTransition:YES animated:YES];
    vc.view.frame = self.bounds;
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self.baseViewController];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSInteger panToIndex = self.currentIndex;
    
    if (self.oldIndex != panToIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
            [self.delegate slideView:self didScrolledViewController:nil atIndex:panToIndex];
        }
    }
    self.panStartPoint = CGPointMake(self.currentIndex*self.bounds.size.width, self.panStartPoint.y);;
    self.oldIndex = panToIndex;
    
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.oldIndex = self.currentIndex;
    CGFloat offsetx = self.collectionView.contentOffset.x - self.panStartPoint.x;
    if (fabs(offsetx) > self.bounds.size.width) {
        NSInteger panToIndex = self.currentIndex;
        self.oldIndex = panToIndex;
        self.panStartPoint = CGPointMake(self.currentIndex*self.bounds.size.width, self.panStartPoint.y);
        offsetx = self.collectionView.contentOffset.x - self.panStartPoint.x;
        if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
            [self.delegate slideView:self didScrolledViewController:nil atIndex:panToIndex];
        }
    }
    NSInteger oldIndex = -1;
    NSInteger panToIndex = -1;
    
    if (offsetx > 0) {
        oldIndex = self.oldIndex;
        panToIndex = self.oldIndex + 1;
    } else if (offsetx < 0) {
        oldIndex = self.oldIndex;
        panToIndex = self.oldIndex - 1;
    }
    
    if (oldIndex >= 0 && panToIndex >= 0 && [self.delegate respondsToSelector:@selector(slideView:scrollingFrom:to:percent:)]) {
        [self.delegate slideView:self scrollingFrom:oldIndex to:panToIndex percent:fabs(offsetx)/self.bounds.size.width];
    }
    NSLog(@"%ld, %ld, %f, %ld", self.oldIndex, panToIndex, scrollView.contentOffset.x, self.collectionView.panGestureRecognizer.state);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    CGFloat offsetx = self.collectionView.contentOffset.x - self.panStartPoint.x;
    if (fabs(offsetx) > self.bounds.size.width) {
        self.oldIndex = self.currentIndex;
        self.panStartPoint = CGPointMake(self.currentIndex*self.bounds.size.width, self.panStartPoint.y);
        offsetx = self.collectionView.contentOffset.x - self.panStartPoint.x;
        
    }
    NSInteger oldIndex = -1;
    NSInteger panToIndex = -1;
    
    if (offsetx > 0) {
        oldIndex = self.oldIndex;
        panToIndex = self.oldIndex + 1;
    } else if (offsetx < 0) {
        oldIndex = self.oldIndex;
        panToIndex = self.oldIndex - 1;
    }
    if (oldIndex >= 0 && panToIndex >= 0 && [self.delegate respondsToSelector:@selector(slideView:scrollingFrom:to:percent:)]) {
        [self.delegate slideView:self scrollingFrom:self.oldIndex to:panToIndex percent:1.0];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didScrolledViewController:atIndex:)]) {
        [self.delegate slideView:self didScrolledViewController:nil atIndex:panToIndex];
    }
    self.panStartPoint = CGPointZero;
    self.oldIndex = -1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
//        if (self.collectionView.dragging || self.collectionView.tracking || self.collectionView.decelerating) {
//            CGFloat offsetx = self.collectionView.contentOffset.x - self.panStartPoint.x;
//            NSInteger oldIndex = -1;
//            NSInteger panToIndex = -1;
//
//            if (offsetx > 0) {
//                oldIndex = self.oldIndex;
//                panToIndex = self.oldIndex + 1;
//            } else if (offsetx < 0) {
//                oldIndex = self.oldIndex + 1;
//                panToIndex = self.oldIndex;
//            }
//
//            if (oldIndex > 0 && panToIndex > 0 && [self.delegate respondsToSelector:@selector(slideView:scrollingFrom:to:percent:)]) {
//                [self.delegate slideView:self scrollingFrom:oldIndex to:panToIndex percent:(labs((NSInteger)offsetx)%(NSInteger)self.bounds.size.width)/self.bounds.size.width];
//            }
//            NSLog(@"%ld, %ld, %f, %ld", self.oldIndex, panToIndex, offsetx, self.collectionView.panGestureRecognizer.state);
//        }
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
