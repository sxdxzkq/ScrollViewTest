//
//  LinkageView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/1.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "LinkageView.h"

@implementation LinkageViewConfig

+ (instancetype)commentConfig {
    
    LinkageViewConfig *config = [[[self class] alloc] init];
    
    config.leftViewPercent = 0.3f;
    config.leftViewBackgroundColor = [UIColor whiteColor];
    config.leftViewSelectedColor = [UIColor lightGrayColor];
    config.leftViewFont = [UIFont systemFontOfSize:14.0f];
    config.leftViewSelectedFont = [UIFont systemFontOfSize:14.0f];
    config.leftViewRowHeight = 50;
    
    return config;
}

@end

@interface LinkageView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LinkageViewConfig *config;

@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UIScrollView *rightView;

@end

@implementation LinkageView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    LinkageViewConfig *config = [LinkageViewConfig commentConfig];
    
    return [self initWithFrame:frame config:config];
}

- (instancetype)initWithFrame:(CGRect)frame config:(LinkageViewConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        [self _commentUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.config = [LinkageViewConfig commentConfig];
    [self _commentUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftTableView.frame = CGRectMake(0, 0, self.bounds.size.width * self.config.leftViewPercent, self.bounds.size.height);
    
    self.rightView.frame = CGRectMake(self.leftTableView.bounds.size.width, 0, self.bounds.size.width-self.leftTableView.bounds.size.width, self.bounds.size.height);
    self.rightView.contentInset = self.leftTableView.contentInset;
}

- (void)_commentUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView = tableView;
    tableView.rowHeight = self.config.leftViewRowHeight;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.estimatedRowHeight = self.config.leftViewRowHeight;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self addSubview:tableView];
}

- (void)addRightView:(UIScrollView *)rightView {
    rightView.contentInset = self.leftTableView.contentInset;
    rightView.frame = CGRectMake(self.leftTableView.bounds.size.width, 0, self.bounds.size.width-self.leftTableView.bounds.size.width, self.bounds.size.height);
    
    [self addSubview:rightView];
    self.rightView = rightView;
    
}

- (void)leftViewScrollSecelted:(NSInteger)index {
    
    if ([self.leftTableView numberOfRowsInSection:0]>index) {
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfLinkageView:)]) {
        return [self.dataSource numberOfLinkageView:self];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(linkageView:leftViewCellForRowAtIndex:)]) {
        return [self.dataSource linkageView:self leftViewCellForRowAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = self.config.leftViewSelectedColor;
        cell.contentView.backgroundColor = self.config.leftViewBackgroundColor;
    }
    
    NSString *text;
    
    if ([self.dataSource respondsToSelector:@selector(linkageView:titleForIndex:)]) {
        text = [self.dataSource linkageView:self titleForIndex:indexPath.row];
    }
    
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(linkageView:leftSelected:)]) {
        [self.delegate linkageView:self leftSelected:indexPath.row];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
