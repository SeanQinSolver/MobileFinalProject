//
//  DetailRunViewController.h
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/28/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@class Run;

@interface DetailRunViewController : UIViewController

@property (strong, nonatomic) Run *currentRun;

- (void)setRun:(Run *)run;
@end
