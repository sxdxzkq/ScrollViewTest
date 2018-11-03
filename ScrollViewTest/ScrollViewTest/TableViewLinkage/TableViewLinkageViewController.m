//
//  TableViewLinkageViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/1.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "TableViewLinkageViewController.h"
#import "LinkageView.h"

@interface TableViewLinkageViewController () <UITableViewDelegate, UITableViewDataSource, LinkageViewDelegate, LinkageViewDataSource>

@property (nonatomic, weak) LinkageView *linkageView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TableViewLinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _commendUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.linkageView.frame = self.view.bounds;
}

- (void)_commendUI {
    LinkageViewConfig *config = [LinkageViewConfig commentConfig];
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

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arc4random()%6 + 4;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%255) / 255.0 green:(arc4random()%255) / 255.0 blue:(arc4random()%255) / 255.0 alpha:1.0];
    
    return cell;
}


#pragma mark - LinkageView
- (NSInteger)numberOfLinkageView:(LinkageView *)linkageView {
    return 10;
}

- (void)linkageView:(nonnull LinkageView *)linkageView leftSelected:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
