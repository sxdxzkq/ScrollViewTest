//
//  HYCollectViewAlignedLayout.m
//  HYCollectionViewAlignedLayoutDemo
//
//  Created by 李思良 on 16/6/26.
//  Copyright © 2016年 lsl. All rights reserved.
//

#import "HYCollectViewAlignedLayout.h"


@interface HYCollectViewAlignedLayout ()

@end

@implementation HYCollectViewAlignedLayout


- (instancetype)initWithType:(HYCollectViewAlignType)type {
    if(self = [super init]) {
        _alignType = type;
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger left = -1, right = -1;//记录每一行最左和最右
    CGFloat width = 0;
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray array];
    for (NSInteger i = 0; i < [originalAttributes count]; i ++) {
        UICollectionViewLayoutAttributes *attributes = originalAttributes[i];
        
        if (!attributes.representedElementKind) {
            NSInteger section = attributes.indexPath.section;
            if (i >= 1) { // 处理当一行中只有一个元素的时候元素居中的情况
                UICollectionViewLayoutAttributes *attributes2;
                attributes2 = originalAttributes[i-1];

                if (attributes2.frame.origin.y < attributes.frame.origin.y) {
                    attributes.frame = CGRectMake([self evaluatedSectionInsetForItemAtIndex:section].left, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
                }

            } else {
                attributes.frame = CGRectMake([self evaluatedSectionInsetForItemAtIndex:section].left, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
            }
            
            if (attributes.frame.origin.x == [self evaluatedSectionInsetForItemAtIndex:section].left ) {
                if(left != -1) {
                   //处理上一行的内容
                    CGFloat offset = attributes.frame.origin.x;
                    switch (_alignType) {
                        case HYCollectViewAlignLeft:
                            break;
                        case HYCollectViewAlignRight:
                            offset += self.collectionView.frame.size.width - width;
                            break;
                        case HYCollectViewAlignMiddle:
                            offset += (self.collectionView.frame.size.width - width) / 2;
                            break;
                        default:
                            break;
                    }
                    [updatedAttributes addObjectsFromArray:[self getAttributesForLeft:left right:right offset:offset originalAttributes:originalAttributes]];
                }
                left = i;
                width = [self evaluatedSectionInsetForItemAtIndex:section].left + [self evaluatedSectionInsetForItemAtIndex:section].right - [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
            }
            
            right = i;
            width += attributes.frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
        }
    }
    
    //最后一行没加上
    if ((updatedAttributes.count != originalAttributes.count) && (left !=-1)) {
        UICollectionViewLayoutAttributes *attributes = originalAttributes[left];
        NSInteger section = attributes.indexPath.section;
        CGFloat offset = [self evaluatedSectionInsetForItemAtIndex:section].left;
        switch (_alignType) {
            case HYCollectViewAlignLeft:
                //                    offset += [self evaluatedSectionInsetForItemAtIndex:section].left;
                break;
            case HYCollectViewAlignRight:
                offset += self.collectionView.frame.size.width - width;
                break;
            case HYCollectViewAlignMiddle:
                offset += (self.collectionView.frame.size.width - width) / 2;
                break;
            default:
                break;
        }
        
        [updatedAttributes addObjectsFromArray:[self getAttributesForLeft:left right:right offset:offset originalAttributes:originalAttributes]];
    }
    
    return updatedAttributes;
}



- (NSArray *)getAttributesForLeft:(NSInteger)left right:(NSInteger) right offset:(CGFloat)offset originalAttributes:(NSArray *)originalAttributes {
    NSMutableArray *updatedAttributes = [NSMutableArray array];
    CGFloat currentOffset = offset;
    
//    NSLog(@"%ld, %ld", left, right);
    
    for(NSInteger i = left; i <= right; i ++) {
        UICollectionViewLayoutAttributes *attributes = originalAttributes[i];
        CGRect frame = attributes.frame;
        frame.origin.x = currentOffset;
        attributes.frame = frame;
        currentOffset += frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:attributes.indexPath.section];
        [updatedAttributes addObject:attributes];
    }
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        attributes.frame = CGRectMake([self evaluatedSectionInsetForItemAtIndex:indexPath.section].left, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
    } else {
        UICollectionViewLayoutAttributes *previousAttributes = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section]];
        if (previousAttributes.frame.origin.y == attributes.frame.origin.y) {
            previousAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section]];
            attributes.frame = CGRectMake(previousAttributes.frame.origin.x + previousAttributes.frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section], attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
        } else {
            attributes.frame = CGRectMake([self evaluatedSectionInsetForItemAtIndex:indexPath.section].left, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
        }
    }
    return attributes;
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}


@end
