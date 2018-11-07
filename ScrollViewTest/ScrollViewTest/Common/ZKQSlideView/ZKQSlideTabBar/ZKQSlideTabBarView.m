//
//  ZKQSlideTabBarView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/7.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQSlideTabBarView.h"

const NSInteger kButtonTagBase = 50;

@implementation ZKQSlideTabBarViewItem

@end

@interface ZKQSlideTabBarView ()

@property (nonatomic, copy) NSArray <ZKQSlideTabBarViewItem *> *tabBarItems;

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *trackImageView;


@end

@implementation ZKQSlideTabBarView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _commonInit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGFloat trackWidth = 0;
    
    if (self.tabBarCount) {
        trackWidth = width / self.tabBarCount;
    }
    
    self.trackImageView.frame = CGRectMake(width * (self.selectedIndex > 0 ? self.selectedIndex : 0), height-self.trackHeight, trackWidth, self.trackHeight);
    
    for (NSInteger i = 0; i < self.backgroundImageView.subviews.count; i++) {
        UIButton *button = [self.backgroundImageView.subviews objectAtIndex:i];
        button.frame = CGRectMake(trackWidth * i, 0, trackWidth, height-self.trackHeight);
    }
    
}

- (void)_commonInit {
    self.trackHeight = 40;
    self.selectedIndex = -1;
    
    UIImageView *backgroudImageView = [[UIImageView alloc] init];
    backgroudImageView.userInteractionEnabled = YES;
    self.backgroundImageView = backgroudImageView;
    [self addSubview:backgroudImageView];
    
    UIImageView *trackImageView = [[UIImageView alloc] init];
    self.trackImageView = trackImageView;
    [self addSubview:trackImageView];
}

#pragma mark - setter && getter
- (NSInteger)tabBarCount {
    return self.tabBarItems.count;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    self.trackImageView.image = trackImage;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    self.trackImageView.backgroundColor = trackColor;
}

- (void)setTrackHeight:(NSInteger)trackHeight {
    _trackHeight = trackHeight;
    [self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (_selectedIndex != selectedIndex) {
        if (_selectedIndex >= 0) {
            ZKQSlideTabBarViewItem *fromItem = [self.tabBarItems objectAtIndex:_selectedIndex];
            UILabel *fromButton = (UILabel *)[self.backgroundImageView viewWithTag:kButtonTagBase+_selectedIndex];
            UIImageView *fromIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+_selectedIndex];
            UIImageView *fromSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+_selectedIndex];
            fromLabel.textColor = fromItem.titleColor;
            fromIamge.alpha = 1.0f;
            fromSelectedIamge.alpha = 0.0f;
        }
        
        if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
            SlideTabBarViewTabItem *toItem = [self.tabbarItems objectAtIndex:selectedIndex];
            UILabel *toLabel = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+selectedIndex];
            UIImageView *toIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+selectedIndex];
            UIImageView *toSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+selectedIndex];
            toLabel.textColor = toItem.selectedTitleColor;
            toIamge.alpha = 0.0f;
            toSelectedIamge.alpha = 1.0f;
        }
        
        float width = self.bounds.size.width/(self.tabbarItems.count?self.tabbarItems.count:2);
        float trackX = width*selectedIndex;
        trackView_.frame = CGRectMake(trackX, trackView_.frame.origin.y, CGRectGetWidth(trackView_.bounds), CGRectGetHeight(trackView_.bounds));
        
        _selectedIndex = selectedIndex;
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
