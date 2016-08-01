//
//  MathController.h
//  RunMaster
//
//  Created by Matt Luedke on 5/20/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatController : NSObject

+ (NSString *)formatDistance:(float)meters;

+ (NSString *)formatDuration:(int)seconds usingLongFormat:(BOOL)longFormat;

+ (NSString *)formatSpeed:(float)meters overTime:(int)seconds;


@end
