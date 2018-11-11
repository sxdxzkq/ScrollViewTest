//
//  ZKQSlideTabBarView.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/7.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQSlideTabBarView.h"
#import "ZKQSlideColorTool.h"

const NSInteger kButtonTagBase = 10000;
const NSInteger kLabelTagBase = 1000;
const NSInteger kSelectedImageTagBase = 2000;
const NSInteger kImageTagBase = 3000;

@implementation ZKQSlideTabBarViewItem

+ (instancetype)commonItem {
    
    ZKQSlideTabBarViewItem *item = [[ZKQSlideTabBarViewItem alloc] init];
    
    item.titleColor = [UIColor colorWithRGB:0x999999];
    item.selectedTitleColor = [UIColor colorWithRGB:0x333333];
    item.textFont = [UIFont systemFontOfSize:14.0f];
    return item;
}

@end

@interface ZKQSlideTabBarView ()

@property (nonatomic, copy) NSArray <ZKQSlideTabBarViewItem *> *tabBarItems;

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *trackImageView;

@property (nonatomic, weak) UIView *lineView;

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
    
    self.lineView.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGFloat trackWidth = 0;
    
    if (self.tabBarCount) {
        trackWidth = width / self.tabBarCount;
    }
    
    self.trackImageView.frame = CGRectMake(width * (self.selectedIndex > 0 ? self.selectedIndex : 0), height-self.trackHeight, trackWidth, self.trackHeight);
    
    for (NSInteger i = 0; i < self.backgroundImageView.subviews.count; i++) {
        
        ZKQSlideTabBarViewItem *item = [self.tabBarItems objectAtIndex:i];
        
        UIButton *button = [self.backgroundImageView.subviews objectAtIndex:i];
        button.frame = CGRectMake(trackWidth * i, 0, trackWidth, height-self.trackHeight);
        
        UILabel *label = [button viewWithTag:kLabelTagBase];
        UIImageView *imageView = [button viewWithTag:kImageTagBase];
        UIImageView *selectedImageView= [button viewWithTag:kSelectedImageTagBase];
        
        if (self.selectedIndex == i) {
            label.textColor = item.selectedTitleColor;
            imageView.alpha = 0.0f;
            selectedImageView.alpha = 1.0f;
        } else {
            label.textColor = item.titleColor;
            imageView.alpha = 1.0f;
            selectedImageView.alpha = 0.0f;
        }
        
        if (item.imageType == ZKQSlideTabBarViewItemImageTypeLeft) {// 左边
            
            CGFloat w = imageView.bounds.size.width + item.imageLabelspace + label.bounds.size.width;
            
            imageView.frame = CGRectMake((button.size.width - w) / 2.0, (button.size.height - imageView.size.height) / 2.0, imageView.bounds.size.width, imageView.bounds.size.height);
            
            CGFloat sw = selectedImageView.bounds.size.width + item.imageLabelspace + label.bounds.size.width;
            
            selectedImageView.frame = CGRectMake((button.size.width - sw) / 2.0, (button.size.height - selectedImageView.size.height) / 2.0, selectedImageView.bounds.size.width, selectedImageView.bounds.size.height);
            
            label.frame = CGRectMake(imageView.frame.origin.x + imageView.bounds.size.width + item.imageLabelspace, (button.size.height - label.size.height) / 2.0, label.bounds.size.width, label.bounds.size.height);
            
        } else {// 右边
            
            CGFloat w = imageView.bounds.size.width + item.imageLabelspace + label.bounds.size.width;
            
            label.frame = CGRectMake((button.size.width - w) / 2.0, (button.size.height - label.size.height) / 2.0, label.bounds.size.width, label.bounds.size.height);
            
            imageView.frame = CGRectMake(label.frame.origin.x + label.bounds.size.width + item.imageLabelspace, (button.size.height - imageView.size.height) / 2.0, imageView.bounds.size.width, imageView.bounds.size.height);
            
            selectedImageView.frame = CGRectMake(label.frame.origin.x + label.bounds.size.width + item.imageLabelspace, (button.size.height - selectedImageView.size.height) / 2.0, selectedImageView.bounds.size.width, selectedImageView.bounds.size.height);
            
        }
        
    }
    
}

#pragma mark - Private
- (void)_commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    self.trackHeight = 7;
    self.selectedIndex = -1;
    
    UIImageView *backgroudImageView = [[UIImageView alloc] init];
    backgroudImageView.userInteractionEnabled = YES;
    self.backgroundImageView = backgroudImageView;
    [self addSubview:backgroudImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0f];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIImageView *trackImageView = [[UIImageView alloc] init];
    self.trackImageView = trackImageView;
    [self addSubview:trackImageView];
}

#pragma mark - Public
- (void)buildTabBarItems:(NSArray<ZKQSlideTabBarViewItem *> *)tabBarItems {
    
    self.tabBarItems = tabBarItems;
    
    for (NSInteger i = 0; i < tabBarItems.count; i++) {
        ZKQSlideTabBarViewItem *item = tabBarItems[i];
        
        UIButton *baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        baseButton.tag = kButtonTagBase + i;
        [baseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundImageView addSubview:baseButton];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = item.title;
        [label sizeToFit];
        label.font = item.textFont;
        label.tag = kLabelTagBase;
        [baseButton addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = kImageTagBase;
        imageView.image = item.image;
        [imageView sizeToFit];
        [baseButton addSubview:imageView];
        
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.tag = kSelectedImageTagBase;
        selectedImageView.image = item.selectedImage;
        [selectedImageView sizeToFit];
        [baseButton addSubview:selectedImageView];
        
    }
    self.selectedIndex = 0;
    [self layoutIfNeeded];
    
}

#pragma mark - Action
- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(slideTabBarCanSelect:)] && [self.delegate slideTabBarCanSelect:self]) {
        NSInteger selectIndex = button.tag - kButtonTagBase;
        if (selectIndex != self.selectedIndex) {
            self.selectedIndex = selectIndex;
            if ([self.delegate respondsToSelector:@selector(slideTabBar:selectAt:)]) {
                [self.delegate slideTabBar:self selectAt:selectIndex];
            }
        }
    }
    
}

#pragma mark - ZKQSlideTabBarProtocol
- (void)scrollingTo:(NSInteger)toIndex percent:(CGFloat)percent {
    ZKQSlideTabBarViewItem *fromItem = [self.tabBarItems objectAtIndex:self.selectedIndex];
    
    UIButton *fromButton = (UIButton *)[self.backgroundImageView viewWithTag:kButtonTagBase + self.selectedIndex];
    
    UILabel *fromLabel = (UILabel *)[fromButton viewWithTag:kLabelTagBase];
    UIImageView *fromIamge = (UIImageView *)[fromButton viewWithTag:kImageTagBase];
    UIImageView *fromSelectedIamge = (UIImageView *)[fromButton viewWithTag:kSelectedImageTagBase];
    fromLabel.textColor = [ZKQSlideColorTool getColorOfPercent:percent between:fromItem.titleColor and:fromItem.selectedTitleColor];
    fromIamge.alpha = percent;
    fromSelectedIamge.alpha = (1-percent);
    
    if (toIndex >= 0 && toIndex < [self tabBarCount]) {
        ZKQSlideTabBarViewItem *toItem = [self.tabBarItems objectAtIndex:toIndex];
        UIButton *toButton = (UIButton *)[self.backgroundImageView viewWithTag:kButtonTagBase + toIndex];
        UILabel *toLabel = (UILabel *)[toButton viewWithTag:kLabelTagBase];
        UIImageView *toIamge = (UIImageView *)[toButton viewWithTag:kImageTagBase];
        UIImageView *toSelectedIamge = (UIImageView *)[toButton viewWithTag:kSelectedImageTagBase];
        toLabel.textColor = [ZKQSlideColorTool getColorOfPercent:percent between:toItem.selectedTitleColor and:toItem.titleColor];
        toIamge.alpha = (1-percent);
        toSelectedIamge.alpha = percent;
    }
    
    float width = self.bounds.size.width/self.tabBarCount;
    float trackX;
    if (toIndex > self.selectedIndex) {
        trackX = width*self.selectedIndex + width*percent;
    } else {
        trackX = width*self.selectedIndex - width*percent;
    }
    
    self.trackImageView.frame = CGRectMake(trackX, self.trackImageView.frame.origin.y, CGRectGetWidth(self.trackImageView.bounds), CGRectGetHeight(self.trackImageView.bounds));
}

- (void)scrollDidIndex:(NSInteger)index {
    _selectedIndex = index;
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
    
    if (!self.tabBarItems.count) {
        _selectedIndex = selectedIndex;
        return;
    }
    
    if (_selectedIndex != selectedIndex) {
        if (_selectedIndex >= 0) {
            ZKQSlideTabBarViewItem *fromItem = [self.tabBarItems objectAtIndex:_selectedIndex];
            UIButton *fromButton = (UIButton *)[self.backgroundImageView viewWithTag:kButtonTagBase+_selectedIndex];
            UILabel *fromLabel = (UILabel *)[fromButton viewWithTag:kLabelTagBase];
            UIImageView *fromIamge = (UIImageView *)[fromButton viewWithTag:kImageTagBase];
            UIImageView *fromSelectedIamge = (UIImageView *)[fromButton viewWithTag:kSelectedImageTagBase];
            fromLabel.textColor = fromItem.titleColor;
            fromIamge.alpha = 1.0f;
            fromSelectedIamge.alpha = 0.0f;
        }
        
        if (selectedIndex >= 0 && selectedIndex < self.tabBarCount) {
            ZKQSlideTabBarViewItem *toItem = [self.tabBarItems objectAtIndex:selectedIndex];
            UIButton *toButton = (UIButton *)[self.backgroundImageView viewWithTag:kButtonTagBase+selectedIndex];
            UILabel *toLabel = (UILabel *)[toButton viewWithTag:kLabelTagBase];
            UIImageView *toIamge = (UIImageView *)[toButton viewWithTag:kImageTagBase];
            UIImageView *toSelectedIamge = (UIImageView *)[toButton viewWithTag:kSelectedImageTagBase];
            toLabel.textColor = toItem.selectedTitleColor;
            toIamge.alpha = 0.0f;
            toSelectedIamge.alpha = 1.0f;
        }
        
        float width = self.bounds.size.width/(self.tabBarItems.count?self.tabBarItems.count:1);
        float trackX = width*selectedIndex;
        self.trackImageView.frame = CGRectMake(trackX, self.trackImageView.frame.origin.y, CGRectGetWidth(self.trackImageView.bounds), CGRectGetHeight(self.trackImageView.bounds));
        
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
