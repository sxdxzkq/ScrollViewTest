//
//  ZKQMemoryCache.m
//  ScrollViewTest
//
//  Created by zkq on 2018/11/6.
//  Copyright © 2018 zkq. All rights reserved.
//

#import "ZKQMemoryCache.h"

@interface ZKQMemoryCache ()

@property (nonatomic, assign) NSInteger cacheCount;

@property (nonatomic, strong) NSMutableArray *lruKeys;

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

@implementation ZKQMemoryCache

- (instancetype)init
{
    return [self initWithCacheCount:4];
}

- (instancetype)initWithCacheCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        self.cacheCount = count;
        self.lruKeys = [NSMutableArray array];
        self.cacheDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (![self.lruKeys containsObject:key]) {
        if (self.lruKeys.count < self.cacheCount) {
            [self.cacheDictionary setValue:object forKey:key];
            [self.lruKeys addObject:key];
        } else {
            NSString *longTimeUnusedKey = [self.lruKeys firstObject];
            [self.cacheDictionary setValue:nil forKey:longTimeUnusedKey];
            [self.lruKeys removeObjectAtIndex:0];
            
            [self.cacheDictionary setValue:object forKey:key];
            [self.lruKeys addObject:key];
        }
    } else {
        [self.cacheDictionary setValue:object forKey:key];
        [self.lruKeys removeObject:key];
        [self.lruKeys addObject:key];
    }
}


- (id)objectForKey:(NSString *)key {
    if ([self.lruKeys containsObject:key]) {
        [self.lruKeys removeObject:key];
        [self.lruKeys addObject:key];
        return [self.cacheDictionary objectForKey:key];
    } else {
        return nil;
    }
}

@end
