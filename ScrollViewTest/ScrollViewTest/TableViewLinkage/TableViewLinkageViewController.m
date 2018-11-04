//
//  TableViewLinkageViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/1.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "TableViewLinkageViewController.h"

#import "LinkageView.h"

#import "TableViewLinkageViewModel.h"



@interface TableViewLinkageViewController () <UITableViewDelegate, UITableViewDataSource, LinkageViewDelegate, LinkageViewDataSource>

@property (nonatomic, weak) LinkageView *linkageView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) TableViewLinkageViewModel *viewModel;

@end

@implementation TableViewLinkageViewController

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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.linkageView addRightView:tableView];
    self.tableView = tableView;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.decelerating || scrollView.dragging || scrollView.tracking) {
        
        NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
        
        NSIndexPath *indexPath = indexPaths.firstObject;
        
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        
        CGFloat top = 0;
        
        if (@available(iOS 11.0, *)) {
            top = self.tableView.safeAreaInsets.top;
        } else {
            // Fallback on earlier versions
            top = self.tableView.contentInset.top;
        }
        
        if (rectInSuperview.origin.y + rectInSuperview.size.height < top && indexPaths.count > 1) {
            NSIndexPath *i = indexPaths[1];
            [self.linkageView leftViewScrollSecelted:i.section];
        } else {
            [self.linkageView leftViewScrollSecelted:indexPath.section];
        }
        
    }
    
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.datas.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[section];
    return sec.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[indexPath.section];
    TableViewLinkageViewModelRow *row = sec.datas[indexPath.row];
    return row.rowHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%ld 行", section];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    TableViewLinkageViewModelSection *sec = self.viewModel.datas[indexPath.section];
    TableViewLinkageViewModelRow *row = sec.datas[indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithRGB:row.colorHex];
    
    return cell;
}

#pragma mark - LinkageView
- (NSInteger)numberOfLinkageView:(LinkageView *)linkageView {
    return self.viewModel.datas.count;
}

- (void)linkageView:(nonnull LinkageView *)linkageView leftSelected:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
