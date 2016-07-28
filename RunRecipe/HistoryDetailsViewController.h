//
//  HistoryDetailsViewController.h
//  RunRecipe
//
//  Created by QinShawn on 7/28/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface HistoryDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *duraLabel;

@property (weak, nonatomic) IBOutlet UILabel *averPaceLabel;

@property (weak, nonatomic) Run *currentRunDetails;
@end
