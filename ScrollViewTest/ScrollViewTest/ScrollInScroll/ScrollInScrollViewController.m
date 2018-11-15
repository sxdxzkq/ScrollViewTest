//
//  ScrollInScrollViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/11.
//  Copyright © 2018 zkq. All rights reserved.
//

// 思路来自: https://www.jianshu.com/p/df01610b4e73

#import "ScrollInScrollViewController.h"



@interface ScrollInScrollViewController ()

@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic, weak) UIScrollView *subScrollView;

@end

@implementation ScrollInScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:scrollView];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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
