//
//  ZKQSlideColorTool.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/8.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZKQSlideColorTool : NSObject
+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2;
@end

NS_ASSUME_NONNULL_END
