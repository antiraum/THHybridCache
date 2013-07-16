//
//  THiOSVersionMacros.h
//  THHeaders
//
//  Created by Thomas Heß on 15.7.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (! defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0))
#define TH_DEPLOYMENT_TARGET_PRE_IOS6(...) \
if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 6) \
{ \
__VA_ARGS__ \
}
#else
#define TH_DEPLOYMENT_TARGET_PRE_IOS6(...)
#endif

