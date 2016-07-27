//
//  SummaryViewController.m
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/26/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "SummaryViewController.h"
#import "Constants.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

//@synthesize lblName, lblDistance, lblSteps, lblCal, lblHeartRate;


- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request{
    NSLog(@"request received");
    
    NSDictionary *credentials = [request getCredentials];
    NSLog(@"creds: %@", credentials);
    
    
    //https://api.fitbit.com/5/user/-/profile.json
    [request get:@"/1/user/-/profile.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         
         if([[output allKeys] count] > 0){
             NSLog(@"output exists: %@:", output);
         } else {
             NSLog(@"output empty");
             NSError *error;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             if([[dictionary allKeys] count] > 0){
                 //NSLog(@"dictionary: %@", dictionary);
                 NSDictionary *user = [dictionary objectForKey:@"user"];
                 NSString *name = [user objectForKey:@"displayName"];
                 NSLog(@"WELCOME!!, %@",name);
                 _lblName.text = [NSString stringWithFormat:@"Hello %@!", name];
                 //TODO if we want imag,e use SDWebImage
                 
                 
                 //image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[user objectForKey:@"avatar"]]];
             }
         }
         
         
         
     }];
    
    //    [request get:@"/1/user/-/activities/goals/daily.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
    //     {
    //         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
    //         NSError *error;
    //         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //         NSDictionary *goals = [dictionary objectForKey:@"goals"];
    //         NSString *stepGoalAmount = [goals objectForKey:@"steps"];
    //         //goalLabel.text = [NSString stringWithFormat:@"Your daily step goal: %@",stepGoalAmount];
    //         NSLog(@"goals: %@", goals);
    //
    //         NSLog(@"stepgoalamt: %@", stepGoalAmount);
    //
    //     }];
    
    
    //    [request get:@"/1/user/-/activities/steps/date/today/1d.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
    //     {
    //         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
    //         NSError *error;
    //         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //         NSDictionary *activities = [dictionary objectForKey:@"activities-steps"];
    //         NSLog(@"dictionary time series: %@", activities);
    //         NSString *steps = [activities valueForKey:@"value"];
    //         goalLabel.text = [NSString stringWithFormat:@"Your current step: %@",steps];
    //         NSLog(@"dictionary time series: %@", activities);
    //
    //         NSLog(@"Steps for today: %@", steps);
    //
    //     }];
    
    [request get:@"/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSDictionary *summary = [dictionary objectForKey:@"summary"];
         //NSLog(@"dictionary time series: %@", summary);
         NSString *cal = [summary valueForKey:@"activityCalories"];
         _lblCal.text = [NSString stringWithFormat:@"Active Calories burnt: %@ cals",cal];
         NSLog(@"activity calorie: %@", cal);
         
         //NSLog(@"Steps for today: %@", steps);
         
     }];
    
    [request get:@"/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSDictionary *summary = [dictionary objectForKey:@"summary"];
         //NSLog(@"dictionary time series: %@", summary);
         NSString *steps = [summary valueForKey:@"steps"];
         _lblSteps.text = [NSString stringWithFormat:@"Total steps: %@ steps",steps];
         
         NSLog(@"Steps for today: %@", steps);
         
     }];
    
    [request get:@"/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSDictionary *summary = [dictionary objectForKey:@"summary"];
         //NSLog(@"dictionary time series: %@", summary);
         NSArray *distances = [summary objectForKey:@"distances"];
         //NSLog(@"The distances array: %@", distances);
         NSDictionary *totalDis = [distances objectAtIndex:0];
         //NSLog(@"The total distances dictionary: %@", totalDis);
         NSString *distance = [totalDis valueForKey:@"distance"];
         //NSLog(@"Distance for today: %@", distance);
         _lblDistance.text = [NSString stringWithFormat:@"Total distance: %@ miles",distance];
     }];
    
    [request get:@"/1/user/-/activities/heart/date/today/1d.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         //NSLog(@"dictionary time series: %@", dictionary);
         NSArray *activities_heart = [dictionary objectForKey:@"activities-heart"];
         //NSLog(@"dictionary time series: %@", activities_heart);
         //NSLog(@"The first: %@", activities_heart[0]);
         NSDictionary *value = [activities_heart valueForKey:@"value"];
         //NSLog(@"Value for today: %@", value);
         NSArray *heartRate = [value valueForKey:@"restingHeartRate"];
         NSString *restRate = heartRate[0];
         _lblHeartRate.text = [NSString stringWithFormat:@"Resting Heart rate: %@ bpm",restRate];
         
         //NSLog(@"HR for today: %@", heartRate);
         //NSLog(@"HR without brackets: %@", restRate);
         
     }];

}



- (void)didFailWithOAuthIOError:(NSError *)error{
    NSLog(@"error: %@", error.localizedDescription);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
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

- (IBAction)btnLogin:(id)sender {
    OAuthIOModal *oauthioModal = [[OAuthIOModal alloc] initWithKey:OAUTH_IO_PUBLIC_KEY delegate:self];
    //    [oauthioModal showWithProvider:@"fitbit"];
    NSLog(@"login tapped");
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:@"true" forKey:@"cache"];
    [oauthioModal showWithProvider:@"fitbit" options:options];
}
@end
