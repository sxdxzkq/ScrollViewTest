//
//  TableViewLinkageViewModel.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/4.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewLinkageViewModelRow : NSObject

@property (nonatomic, assign) CGFloat rowHight;

@property (nonatomic, assign) uint32_t colorHex;

@end

@interface TableViewLinkageViewModelSection : NSObject

@property (nonatomic, strong) NSMutableArray <TableViewLinkageViewModelRow *> *datas;

@end

@interface TableViewLinkageViewModel : NSObject

@property (nonatomic, strong) NSMutableArray <TableViewLinkageViewModelSection *> *datas;

@end

NS_ASSUME_NONNULL_END
