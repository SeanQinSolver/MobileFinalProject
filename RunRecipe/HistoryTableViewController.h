//
//  HistoryTableViewController.h
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/23/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartRunViewController.h"
#import "HistoryDetailsViewController.h"
#import "MathController.h"
@interface HistoryTableViewController : UITableViewController

@property (strong, nonatomic) NSArray<Run *> *historyRecords;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
