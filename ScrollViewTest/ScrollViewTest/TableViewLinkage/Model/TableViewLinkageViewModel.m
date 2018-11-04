//
//  TableViewLinkageViewModel.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/4.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "TableViewLinkageViewModel.h"

@implementation TableViewLinkageViewModelRow

- (CGFloat)rowHight {
    
    if (!_rowHight) {
        _rowHight = arc4random()%200 / 2.0 + 50;
    }
    return _rowHight;
    
}

- (uint32_t)colorHex {
    if (!_colorHex) {
        _colorHex = arc4random()%0xffffff;
    }
    return _colorHex;
}

@end

@implementation TableViewLinkageViewModelSection

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 0; i < arc4random()%14+6; i++) {
            TableViewLinkageViewModelRow *row = [[TableViewLinkageViewModelRow alloc] init];
            [_datas addObject:row];
        }
    }
    return _datas;
}

@end

@implementation TableViewLinkageViewModel

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            TableViewLinkageViewModelSection *section = [[TableViewLinkageViewModelSection alloc] init];
            [_datas addObject:section];
        }
    }
    return _datas;
}

@end
