//
//  THFloatEqualToFloat.h
//  THHeaders
//
//  Created by Thomas Heß on 12.8.13.
//  Copyright (c) 2013 Thomas Heß. All rights reserved.
//

#define THFloatComparisonEpsilon 0.0001
#define THFloatEqualToFloat(f1, f2) (fabs(f1 - f2) < THFloatComparisonEpsilon)
