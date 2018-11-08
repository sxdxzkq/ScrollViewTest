//
//  ZKQTabBarProtocol.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/7.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZKQSlideTabbarDelegate <NSObject>
@optional;
- (BOOL)slideTabbarCanSelect:(id)sender;
- (void)slideTabbar:(id)sender selectAt:(NSInteger)index;
@end

@protocol ZKQSlideTabBarProtocol <NSObject>

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly, assign) NSInteger tabBarCount;
@property(nonatomic, weak) id <ZKQSlideTabbarDelegate> delegate;
- (void)scrollingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;


@end

NS_ASSUME_NONNULL_END
