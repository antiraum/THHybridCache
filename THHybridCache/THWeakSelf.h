//
//  THWeakSelf.h
//  THHeaders
//
//  Created by Thomas Heß on 15.7.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

/// For when you need a weak reference of an object, example: `THWeakObject(obj) wobj = obj;`
#define THWeakObject(o) __weak __typeof__((__typeof__(o))o)
/// For when you need a weak reference to self, example: `THWeakSelf wself = self;`
#define THWeakSelf THWeakObject(self)
