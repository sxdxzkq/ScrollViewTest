//
//  ZKQMemoryCache.h
//  ScrollViewTest
//
//  Created by zkq on 2018/11/6.
//  Copyright © 2018 zkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKQMemoryCache : NSObject

@property (nonatomic, assign, readonly) NSInteger cacheCount;

- (instancetype)initWithCacheCount:(NSInteger)count;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
