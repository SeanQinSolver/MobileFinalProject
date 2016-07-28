//
//  HistoryDetailsViewController.m
//  RunRecipe
//
//  Created by QinShawn on 7/28/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "HistoryDetailsViewController.h"

@interface HistoryDetailsViewController ()

@end

@implementation HistoryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _duraLabel.text = [NSString stringWithFormat:@"%d", _currentRunDetails.duration.intValue];
    _distLabel.text = [NSString stringWithFormat:@"%.2f", _currentRunDetails.distance.floatValue];
    float pace = _currentRunDetails.distance.floatValue / _currentRunDetails.duration.floatValue;
    _averPaceLabel.text = [NSString stringWithFormat:@"%.2f", pace];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
