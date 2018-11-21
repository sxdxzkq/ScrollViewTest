//
//  CollectionViewLinkageViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/4.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "CollectionViewLinkageViewController.h"

#import "LinkageView.h"

#import "TableViewLinkageViewModel.h"

#import "HYCollectViewAlignedLayout.h"
#import "ZKQCollectViewAlignedLayout.h"

@interface CollectionViewLinkageViewController () <LinkageViewDelegate, LinkageViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, weak) LinkageView *linkageView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) TableViewLinkageViewModel *viewModel;

@end

@implementation CollectionViewLinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[TableViewLinkageViewModel alloc] init];
    [self _commonUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.linkageView.frame = self.view.bounds;
    
    [self.linkageView leftViewScrollSecelted:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)_commonUI {
    
    LinkageViewConfig *config = [LinkageViewConfig commentConfig];
    config.leftViewBackgroundColor = [UIColor redColor];
    config.leftViewSelectedColor = [UIColor blueColor];
    LinkageView *linkageView = [[LinkageView alloc] initWithFrame:CGRectZero config:config];
    linkageView.delegate = self;
    linkageView.dataSource = self;
    [self.view addSubview:linkageView];
    self.linkageView = linkageView;
    
//    HYCollectViewAlignedLayout *layout = [[HYCollectViewAlignedLayout alloc] initWithType:HYCollectViewAlignLeft];
    ZKQCollectViewAlignedLayout *layout = [[ZKQCollectViewAlignedLayout alloc] initWithType:ZKQCollectViewAlignLeft];
    layout.sectionHeadersPinToVisibleBounds = YES;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    self.collectionView = collectionView;
    [self.linkageView addRightView:collectionView];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.decelerating || scrollView.dragging || scrollView.tracking) {
        // 暂时还没想到什么好的计算方法
        NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];

        NSIndexPath *indexPath = indexPaths.firstObject;
        
        CGRect rectInTableView = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
        CGRect rectInSuperview = [self.collectionView convertRect:rectInTableView toView:[self.collectionView superview]];

        CGFloat top = 0;

        if (@available(iOS 11.0, *)) {
            top = self.collectionView.safeAreaInsets.top;
        } else {
            // Fallback on earlier versions
            top = self.collectionView.contentInset.top;
        }

        if (rectInSuperview.origin.y + rectInSuperview.size.height < top && indexPaths.count > 1) {
            NSIndexPath *i = indexPaths[1];
            [self.linkageView leftViewScrollSecelted:i.section];
        } else {
            [self.linkageView leftViewScrollSecelted:indexPath.section];
        }
        
//        CGFloat top = 0;
//
//        if (@available(iOS 11.0, *)) {
//            top = self.collectionView.safeAreaInsets.top;
//        } else {
//            // Fallback on earlier versions
//            top = self.collectionView.contentInset.top;
//        }
//
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(20, self.collectionView.contentOffset.y+top)];
//
//        NSLog(@"%ld, %ld, %f", indexPath.section, indexPath.row, self.collectionView.contentOffset.y+top);
        
    }
    
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    NSLog(@"%ld", self.model.items.count);
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[section];
    return sec.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[indexPath.section];
    TableViewLinkageViewModelRow *row = sec.datas[indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor colorWithRGB:row.colorHex];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        TableViewLinkageViewModelSection *sec = self.viewModel.datas[indexPath.section];
        TableViewLinkageViewModelRow *row = sec.datas[0];
        header.backgroundColor = [UIColor colorWithRGB:row.colorHex];
        return header;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.bounds.size.width, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[indexPath.section];
    TableViewLinkageViewModelRow *row = sec.datas[indexPath.row];
    return CGSizeMake(row.rowHight/2.0, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3, 18, 18, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - LinkageView
- (NSInteger)numberOfLinkageView:(LinkageView *)linkageView {
    return self.viewModel.datas.count;
}

- (void)linkageView:(nonnull LinkageView *)linkageView leftSelected:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
//    [self.collectionView scrollRectToVisible:<#(CGRect)#> animated:<#(BOOL)#>];
//
//    [self.collectionView ]
}

- (NSString *)linkageView:(LinkageView *)linkageView titleForIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%ld 行", index];
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
