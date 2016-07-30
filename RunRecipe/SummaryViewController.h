//
//  SummaryViewController.h
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/26/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OAUthiOS/OAuthiOS.h>
#import "PNChart.h"
#import "Run.h"
#import "AppDelegate.h"

@interface SummaryViewController : UIViewController<OAuthIODelegate, PNChartDelegate>
//{
//    IBOutlet UILabel *lblName;
//    IBOutlet UILabel *lblDistance;
//    IBOutlet UILabel *lblSteps;
//    IBOutlet UILabel *lblCal;
//    IBOutlet UILabel *lblHeartRate;
//}


@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblSteps;
@property (weak, nonatomic) IBOutlet UILabel *lblCal;
@property (weak, nonatomic) IBOutlet UILabel *lblHeartRate;
@property (nonatomic) PNLineChart * lineChart;


- (IBAction)btnLogin:(id)sender;

@property (strong, nonatomic) NSArray<Run *> *historyRecords;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
