//
//  THLog.h
//  THHeaders
//
//  Created by Thomas Heß on 15.7.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

// DLog is displayed if DEBUG is set
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// Only show NSLog calls if DEBUG is set
#ifndef DEBUG
#   define NSLog(...) DLog(...)
#endif
