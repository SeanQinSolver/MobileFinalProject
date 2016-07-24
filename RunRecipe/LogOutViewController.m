//
//  LogOutViewController.m
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/22/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "LogOutViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "LogInViewController.h"


@interface LogOutViewController ()

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Log Out
- (IBAction)btnLogout:(id)sender {
    NSString *signedInUserID = [TWTRAPIClient clientWithCurrentUser].userID;
    NSLog(@"Log out user: %@", signedInUserID);

    [[[Twitter sharedInstance] sessionStore] logOutUserID:signedInUserID];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LogInViewController *initView =  (LogInViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    [initView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:initView animated:NO completion:nil];
    
    NSLog(@"Log out successfully");
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
