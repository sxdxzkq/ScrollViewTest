//
//  ZKQSlideCollectionView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/11.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQSlideCollectionView.h"

@implementation ZKQSlideCollectionView

#pragma mark - UIGestureRecognizerDelagate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.popGestureRecognizer == otherGestureRecognizer && self.contentOffset.x <= 0) {
        return YES;
    } else {
        return NO;
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
