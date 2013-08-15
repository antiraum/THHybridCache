//
//  THAppDelegate.m
//  THHybridCacheDemo
//
//  Created by Thomas Heß on 5.10.12.
//  Copyright (c) 2012 Thomas Heß. All rights reserved.
//

#import "THAppDelegate.h"
#import "THHybridCache.h"

@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // configure
    [[THHybridCache sharedCache] setMemoryCacheSize:100];
    [[THHybridCache sharedCache] setTimeout:(24 * 60 * 60)];
    [[THHybridCache sharedCache] setJpgQuality:0.8];
    
    // cache an image (in memory and/or disk, as PNG or JPG)
    UIImage* img = [UIImage imageNamed:@"test"];
    NSString* imgKey = @"testImgKey";
//    [[THHybridCache sharedCache] cacheImage:img forKey:imgKey inMemory:YES onDisk:YES hasTransparency:YES];
    
    // query the cache
    if ([[THHybridCache sharedCache] hasCacheForKey:imgKey onlyInMemory:YES])
        NSLog(@"image is cached in memory");
    if ([[THHybridCache sharedCache] hasCacheForKey:imgKey onlyInMemory:NO])
        NSLog(@"image is cached in memory or disk");
    
    // access cached images
    UIImage* imgFromMemoryCache = [[THHybridCache sharedCache] imageForKey:imgKey onlyFromMemory:YES];
    UIImage* imgFromMemoryOrDiskCache = [[THHybridCache sharedCache] imageForKey:imgKey onlyFromMemory:NO];
    
    // remove from cache
    [[THHybridCache sharedCache] removeCacheForKey:imgKey];
    
    // clean the cache (enforces the timeout)
    [[THHybridCache sharedCache] cleanCache];
    
    // clear the cache
    [[THHybridCache sharedCache] clearCache];
    
    // Override point for customization after application launch.
    [[THHybridCache sharedCache] cleanCache];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
