THHybridCache
=============

Hybrid memory and disk cache for UIImages.

Features
--------

* Caches UIImage instances in a NSCache
* Saves UIImage representations on disk as JPGs and PNGs
* Performs disk writes in a background queue

Usage
-----

	// configure
    [[THHybridCache sharedCache] setMemoryCacheSize:100];
    [[THHybridCache sharedCache] setTimeout:(24 * 60 * 60)];
    [[THHybridCache sharedCache] setJpgQuality:0.8];
    
    // cache an image (in memory and/or on disk, as PNG or JPG)
    UIImage* img = [UIImage imageNamed:@"test"];
    NSString* imgKey = @"testImgKey";
    [[THHybridCache sharedCache] cacheImage:img forKey:imgKey inMemory:YES onDisk:YES hasTransparency:YES];
    
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

License
-------

Made available under the MIT License.

Collaboration
-------------

If you have any feature requests or bugfixes feel free to help out and send a pull request, or create a new issue.
