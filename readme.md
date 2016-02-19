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

Installation
-------

###As a Git Submodule

	git submodule add git://github.com/antiraum/THHybridCache.git <local path>
	git submodule update

###Via CocoaPods

Add this line to your Podfile:

    pod 'THHybridCache', '~> 1.0.0'
	
Compatibility
-------

THHybridCache requires iOS 6.0 and above. 

THHybridCache uses ARC. If you are using THHybridCache in your non-ARC project, you need to set the `-fobjc-arc` compiler flag for the THHybridCache.m source file.

License
-------

Made available under the MIT License.

Collaboration
-------------

If you have any feature requests or bugfixes feel free to help out and send a pull request, or create a new issue.
