//
//  THHybridCache.h
//  THHybridCache
//
//  Created by Thomas Heß on 20.9.12.
//  Copyright (c) 2012 Thomas Heß. All rights reserved.
//

@interface THHybridCache : NSObject

// number of items cached in memory (defaults to 100)
@property (nonatomic, assign) NSUInteger memoryCacheSize;
// time interval items are cached, in seconds (defaults to one day)
@property (nonatomic, assign) NSUInteger timeout;
// compression quality of JPG representations from 0.0 to 1.0 (defaults to 0.8)
@property (nonatomic, assign) CGFloat jpgQuality;

+ (THHybridCache*)sharedCache;

- (BOOL)hasCacheForKey:(NSString*)key onlyInMemory:(BOOL)onlyInMemory;
- (UIImage*)imageForKey:(NSString*)key onlyFromMemory:(BOOL)onlyFromMemory;
- (void)setImage:(UIImage*)img forKey:(NSString*)key inMemory:(BOOL)inMemory
          onDisk:(BOOL)onDisk hasTransparency:(BOOL)hasTransparency; // hasTransparency triggers the use of PNG or JPG representations
- (void)removeCacheForKey:(NSString*)key;
- (void)cleanCache; // call this regularly (e.g., on each app start) to enforce the timeout
- (void)clearCache; // empties the cache

@end
