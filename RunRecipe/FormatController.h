//
//  FormatController.h
//  
//


#import <Foundation/Foundation.h>

@interface FormatController : NSObject

+ (NSString *)formatDistance:(float)meters;

+ (NSString *)formatDuration:(int)seconds usingLongFormat:(BOOL)longFormat;

+ (NSString *)formatSpeed:(float)meters overTime:(int)seconds;


@end
