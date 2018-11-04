//
//  LinkageView.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/1.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LinkageView;

@protocol LinkageViewDelegate <NSObject>

@required

- (void)linkageView:(LinkageView *)linkageView leftSelected:(NSInteger)index;

@optional

- (CGFloat)linkageView:(LinkageView *)linkageView heightForRowAtIndex:(NSInteger)index;

@end

@protocol LinkageViewDataSource <NSObject>

@required
- (NSInteger)numberOfLinkageView:(LinkageView *)linkageView;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

@optional

/*
 二选一
 linkageView:titleForIndex: 使用默认实现
 linkageView:leftViewCellForRowAtIndex: 自定义程度更高
 */
- (nullable NSString *)linkageView:(LinkageView *)linkageView titleForIndex:(NSInteger)index;
- (UITableViewCell *)linkageView:(LinkageView *)linkageView leftViewCellForRowAtIndex:(NSInteger)index;

@end

@interface LinkageViewConfig : NSObject

// 左边View百分比
@property (nonatomic, assign) CGFloat leftViewPercent;

// 完成无效
@property (nonatomic, assign) CGFloat leftViewRowHeight;

// 完成linkageView:leftViewCellForRowAtIndex:无效
@property (nonatomic, strong) UIColor *leftViewBackgroundColor;
// 完成linkageView:leftViewCellForRowAtIndex:无效
@property (nonatomic, strong) UIColor *leftViewSelectedColor;
// 完成linkageView:leftViewCellForRowAtIndex:无效
@property (nonatomic, strong) UIFont *leftViewFont;
// 完成linkageView:leftViewCellForRowAtIndex:无效
@property (nonatomic, strong) UIFont *leftViewSelectedFont;

+ (instancetype)commentConfig;

@end

@interface LinkageView : UIView

@property (nonatomic, strong, readonly) LinkageViewConfig *config;

@property (nonatomic, weak) id <LinkageViewDelegate> delegate;
@property (nonatomic, weak) id <LinkageViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame config:(LinkageViewConfig *)config;

- (void)addRightView:(UIScrollView *)rightView;

- (void)leftViewScrollSecelted:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
