//
//  FormatController.m
//
//
//  Reference: https://github.com/mluedke2/moonrunner
//  A controller that helps stringify data

#import "FormatController.h"
#import "Location.h"

static bool const isMetric = NO;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation FormatController

+ (NSString *)formatDistance:(float)meters {
    
    float unitDivider;
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"km";
        
        // to get from meters to kilometers divide by this
        unitDivider = metersInKM;
        
    // U.S.
    } else {
        
        unitName = @"mi";
        
        // to get from meters to miles divide by this
        unitDivider = metersInMile;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)formatDuration:(int)seconds usingLongFormat:(BOOL)longFormat {
    
    int remainingSeconds = seconds;
    
    int hours = remainingSeconds / 3600;
    
    remainingSeconds = remainingSeconds - hours * 3600;
    
    int minutes = remainingSeconds / 60;
    
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

+ (NSString *)formatSpeed:(float)meters overTime:(int)seconds;
{
    if (seconds == 0 || meters == 0) {
        return @"0";
    }
        
    NSString *unitName;
    
    unitName = @"meters/sec";
    
    float avgPaceMetersPerSec = meters / seconds;
    return [NSString stringWithFormat:@"%.02f %@", avgPaceMetersPerSec, unitName];
}



@end
