//
//  TableViewLinkageViewModel.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/4.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "TableViewLinkageViewModel.h"

@implementation TableViewLinkageViewModelRow

@end

@implementation TableViewLinkageViewModelSection

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            TableViewLinkageViewModelRow *section = [[TableViewLinkageViewModelRow alloc] init];
            [_datas addObject:section];
        }
    }
    return _datas;
}

@end

@implementation TableViewLinkageViewModel

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            TableViewLinkageViewModelSection *section = [[TableViewLinkageViewModelSection alloc] init];
            [_datas addObject:section];
        }
    }
    return _datas;
}

@end
