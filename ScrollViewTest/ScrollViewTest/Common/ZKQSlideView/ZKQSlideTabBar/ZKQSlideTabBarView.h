//
//  ZKQSlideTabBarView.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/7.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZKQSlideTabBarProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZKQSlideTabBarViewItemImageType) {
    ZKQSlideTabBarViewItemImageTypeLeft,
    ZKQSlideTabBarViewItemImageTypeRight,
};

@interface ZKQSlideTabBarViewItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat imageLabelspace;
@property (nonatomic, assign) ZKQSlideTabBarViewItemImageType imageType;

+ (instancetype)commonItem;

@end

@interface ZKQSlideTabBarView : UIView <ZKQSlideTabBarProtocol>

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIImage *trackImage;
@property (nonatomic, assign) NSInteger trackHeight;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readonly) NSInteger tabBarCount;
@property (nonatomic, copy, readonly) NSArray <ZKQSlideTabBarViewItem *> *tabBarItems;

@property (nonatomic, weak) id <ZKQSlideTabbarDelegate> delegate;

- (void)buildTabBarItems:(NSArray <ZKQSlideTabBarViewItem *> *)tabBarItems;

- (void)scrollingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(CGFloat)percent;


@end

NS_ASSUME_NONNULL_END
