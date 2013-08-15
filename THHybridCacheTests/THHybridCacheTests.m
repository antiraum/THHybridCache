//
//  THHybridCacheTests.m
//  THHybridCacheTests
//
//  Created by Thomas Heß on 13.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "THHybridCache.h"
#import "THFloatEqualToFloat.h"

@interface THHybridCacheTests : XCTestCase

@property (nonatomic, strong) NSBundle* bundle;

@end

@implementation THHybridCacheTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.bundle = [NSBundle bundleForClass:[self class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[THHybridCache sharedCache] clearCache];
    [super tearDown];
}

- (void)testConfiguration
{
    NSUInteger cacheSize = 100;
    [[THHybridCache sharedCache] setMemoryCacheSize:cacheSize];
    XCTAssertTrue([[THHybridCache sharedCache] memoryCacheSize] == cacheSize, @"wrong cache size");
    NSUInteger timeout = 24 * 60 * 60;
    [[THHybridCache sharedCache] setTimeout:timeout];
    XCTAssertTrue([[THHybridCache sharedCache] timeout] == timeout, @"wrong timeout");
    CGFloat jpgQuality = 0.8;
    [[THHybridCache sharedCache] setJpgQuality:jpgQuality];
    XCTAssertEqualWithAccuracy([[THHybridCache sharedCache] jpgQuality], jpgQuality,
                               THFloatComparisonEpsilon, @"wrong jpg quality");
}

- (void)testCaching
{
    // test hybrid caching
    NSString* file1 = @"file000704292456";
    UIImage* img1 = [self jpgWithName:file1];
    XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO],
                   @"wrong cache status");
    [[THHybridCache sharedCache] cacheImage:img1 forKey:file1 inMemory:YES onDisk:YES
                            hasTransparency:NO];
    XCTAssertTrue([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO],
                  @"wrong cache status");
    XCTAssertNotNil([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:YES],
                    @"img not cached");
    XCTAssertNotNil([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:NO],
                    @"img not cached");
    
    // test cache removal
    [[THHybridCache sharedCache] removeCacheForKey:file1];
    // wait for cacheDictionaryAccessQueue
    dispatch_queue_t cacheDictionaryAccessQueue = [[THHybridCache sharedCache] performSelector:@selector(cacheDictionaryAccessQueue)];
    dispatch_barrier_sync(cacheDictionaryAccessQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO],
                           @"wrong cache status");
            XCTAssertNil([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:YES],
                         @"img should not be cached");
            XCTAssertNil([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:NO],
                         @"img should not be cached");
        });
    });
    
    // test disk only caching
    NSString* file2 = @"file000714103327";
    UIImage* img2 = [self jpgWithName:file2];
    XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file2 onlyInMemory:NO],
                   @"wrong cache status");
    [[THHybridCache sharedCache] cacheImage:img2 forKey:file2 inMemory:NO onDisk:YES
                            hasTransparency:YES];
    // wait for diskWriteQueue
    dispatch_queue_t diskWriteQueue = [[THHybridCache sharedCache] performSelector:@selector(diskWriteQueue)];
    dispatch_barrier_sync(diskWriteQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertTrue([[THHybridCache sharedCache] hasCacheForKey:file2 onlyInMemory:NO],
                          @"wrong cache status");
            XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file2 onlyInMemory:YES],
                           @"wrong cache status");
            XCTAssertNotNil([[THHybridCache sharedCache] imageForKey:file2 onlyFromMemory:NO],
                            @"img not cached");
            XCTAssertNil([[THHybridCache sharedCache] imageForKey:file2 onlyFromMemory:YES],
                         @"img should not be in memory cache");
        });
    });
    
    // test cache clearing
    [[THHybridCache sharedCache] clearCache];
    // wait for cacheDictionaryAccessQueue
    dispatch_barrier_sync(cacheDictionaryAccessQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file2 onlyInMemory:NO],
                           @"wrong cache status");
            XCTAssertNil([[THHybridCache sharedCache] imageForKey:file2 onlyFromMemory:NO],
                         @"img should not be in cache");
        });
    });
}

- (void)testCacheSize
{
    [[THHybridCache sharedCache] setMemoryCacheSize:2];
    NSString* file1 = @"file000704292456";
    UIImage* img1 = [self jpgWithName:file1];
    [[THHybridCache sharedCache] cacheImage:img1 forKey:file1 inMemory:YES onDisk:NO
                            hasTransparency:NO];
    XCTAssertTrue([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO],
                  @"wrong cache status");
    XCTAssertNotNil([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:NO],
                    @"img not cached");
    NSString* file2 = @"file000162678218";
    UIImage* img2 = [self jpgWithName:file2];
    [[THHybridCache sharedCache] cacheImage:img2 forKey:file2 inMemory:YES onDisk:NO
                            hasTransparency:NO];
    NSString* file3 = @"file000714103327";
    UIImage* img3 = [self jpgWithName:file3];
    [[THHybridCache sharedCache] cacheImage:img3 forKey:file3 inMemory:YES onDisk:NO
                            hasTransparency:NO];
    XCTAssertTrue([[THHybridCache sharedCache] hasCacheForKey:file3 onlyInMemory:NO],
                  @"wrong cache status");
    XCTAssertNotNil([[THHybridCache sharedCache] imageForKey:file3 onlyFromMemory:NO],
                    @"img not cached");
    XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO]
                   && [[THHybridCache sharedCache] hasCacheForKey:file2 onlyInMemory:NO],
                   @"wrong cache status");
    XCTAssertFalse([[THHybridCache sharedCache] imageForKey:file1 onlyFromMemory:NO]
                   && [[THHybridCache sharedCache] imageForKey:file2 onlyFromMemory:NO],
                   @"img cached despite cache size");
}

- (void)testTimeout
{
    NSUInteger timeout = 1;
    [[THHybridCache sharedCache] setTimeout:timeout];
    NSString* file1 = @"file000162678218";
    UIImage* img1 = [self jpgWithName:file1];
    [[THHybridCache sharedCache] cacheImage:img1 forKey:file1 inMemory:YES onDisk:YES
                            hasTransparency:YES];
    XCTAssertTrue([[THHybridCache sharedCache] hasCacheForKey:file1 onlyInMemory:NO],
                  @"wrong cache status");
    [NSTimer timerWithTimeInterval:1 target:self selector:@selector(checkCacheAfterTimeout:)
                          userInfo:file1 repeats:NO];
}

- (void)checkCacheAfterTimeout:(NSTimer*)timer
{
    [timer invalidate];
    [[THHybridCache sharedCache] cleanCache];
    XCTAssertFalse([[THHybridCache sharedCache] hasCacheForKey:timer.userInfo onlyInMemory:NO],
                   @"wrong cache status");
}

- (UIImage*)jpgWithName:(NSString*)name
{
    NSString* path = [self.bundle pathForResource:name ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
