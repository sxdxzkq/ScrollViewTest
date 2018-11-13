//
//  ScrollInScrollViewController.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/11.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ScrollInScrollViewController.h"

@interface ScrollInScrollViewController ()

@end

@implementation ScrollInScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //暂时选用手势模拟...
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 1000000);
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
