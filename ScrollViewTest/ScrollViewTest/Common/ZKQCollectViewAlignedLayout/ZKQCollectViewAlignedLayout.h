//
//  ZKQCollectViewAlignedLayout.h
//  TraditionalChineseDoctor
//
//  Created by kjwx on 2017/12/21.
//  Copyright © 2017年 kjwx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZKQCollectViewAlignType) {
    ZKQCollectViewAlignLeft,
    ZKQCollectViewAlignMiddle,
    ZKQCollectViewAlignRight,
};
@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>
@end

@interface ZKQCollectViewAlignedLayout : UICollectionViewFlowLayout

@property (nonatomic, readonly) ZKQCollectViewAlignType alignType;

- (instancetype)initWithType:(ZKQCollectViewAlignType)type;

@end
