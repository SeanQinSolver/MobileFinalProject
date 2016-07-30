//
//  TimelineViewController.m
//  RunRecipe
//  Ref: https://docs.fabric.io/apple/twitter/show-timelines.html
//  Created by Chuanyu Chen on 7/23/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
    self.title = @"Running Recipe";
    
    // Do any additional setup after loading the view.
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"runnersworld" APIClient:client];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Change color of cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(TWTRTweetTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1];
    cell.tweetView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1];
    
    
    // Do what you want with your 'tweetView' object
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
