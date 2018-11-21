//
//  ViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/10/31.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ViewController.h"

#import "TableViewLinkageViewController.h"
#import "CollectionViewLinkageViewController.h"
#import "TabBarSlideViewController.h"
#import "ScrollSlideViewController.h"
#import "ScrollInScrollViewController.h"
#import "UpdateImageViewController.h"

#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self _commonUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.view.safeAreaInsets.bottom, 0);
    } else {
        // Fallback on earlier versions
    }
}

- (void)_commonUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSArray *)datas {
    if (!_datas) {
        _datas = @[@"TableView联动", @"CollectionView联动(未完成)", @"TabBarSlideView", @"ScrollSlideView", @"ScrollInScrollViewController", @"UpdateImage"];
    }
    return _datas;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[TableViewLinkageViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[CollectionViewLinkageViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[TabBarSlideViewController alloc] init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[ScrollSlideViewController alloc] init] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[[ScrollInScrollViewController alloc] init] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[[UpdateImageViewController alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
    
}

@end
