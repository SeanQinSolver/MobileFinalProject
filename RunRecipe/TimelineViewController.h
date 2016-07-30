//
//  TimelineViewController.h
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/23/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface TimelineViewController : TWTRTimelineViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
