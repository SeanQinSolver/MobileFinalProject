//
//  SummaryViewController.m
//  RunRecipe
//  Utilize package from https://github.com/kevinzhow/PNChart to draw chart
//  Created by Chuanyu Chen on 7/26/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "SummaryViewController.h"
#import "Constants.h"
#import "FormatController.h"

@interface SummaryViewController () {
    NSMutableArray *disArray;
    NSMutableArray *dateArray;
}
@property (weak, nonatomic) IBOutlet UIButton *lblFitbitBtn;

@end

@implementation SummaryViewController

//@synthesize lblName, lblDistance, lblSteps, lblCal, lblHeartRate;


- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request{
    NSLog(@"request received");
    
    NSDictionary *credentials = [request getCredentials];
    NSLog(@"creds: %@", credentials);
    
    
    //https://api.fitbit.com/5/user/-/profile.json
    
    //Get user name
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
    
    //Get calorie for today
    [request get:@"/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSDictionary *summary = [dictionary objectForKey:@"summary"];
         //NSLog(@"dictionary time series: %@", summary);
         NSString *cal = [summary valueForKey:@"activityCalories"];
         _lblCal.text = [NSString stringWithFormat:@"Today Calories burnt: %@ cals",cal];
         //NSLog(@"activity calorie: %@", cal);
     }];
    
    //Get steps for today
    [request get:@"/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSDictionary *summary = [dictionary objectForKey:@"summary"];
         //NSLog(@"dictionary time series: %@", summary);
         NSString *steps = [summary valueForKey:@"steps"];
         _lblSteps.text = [NSString stringWithFormat:@"Today steps: %@ steps",steps];
         
         //NSLog(@"Steps for today: %@", steps);
         
     }];
    
    
    //Get distances for today
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
         _lblDistance.text = [NSString stringWithFormat:@"Today distance: %@ miles",distance];
     }];
    
    //Get resting heart rate for today
    [request get:@"/1/user/-/activities/heart/date/today/1d.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         
         //NSLog(@"dictionary time series: %@", dictionary);
         NSArray *activities_heart = [dictionary objectForKey:@"activities-heart"];
         NSLog(@"*****dictionary time series: %@", activities_heart);
         //NSLog(@"The first: %@", activities_heart[0]);
         NSDictionary *value = [activities_heart valueForKey:@"value"];
         //NSLog(@"Value for today: %@", value);
         NSArray *heartRate = [value valueForKey:@"restingHeartRate"];
         NSString *restRate = heartRate[0];
         NSLog(@"HR for today: %@", restRate);

         //Check if Null
         if (restRate) {
             //NSLog(@"Heart %@", restRate);
             _lblHeartRate.text = [NSString stringWithFormat:@"Resting Heart rate: %@ bpm",restRate];
         } else {
             _lblHeartRate.text = [NSString stringWithFormat:@"Resting Heart rate: not sync"];
         }
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

- (void)viewWillAppear:(BOOL)animated {
    //Clear the view for refreshing
    [_lineChart removeFromSuperview];
    
    disArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    
    
    //Pass context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    //Get History Run
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _historyRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //Get distance array
    int arraysize = (int)_historyRecords.count;
    NSLog(@"Record size: %d", arraysize);
    for (int i= arraysize - 1, j = 0; i >= 0 ; i--, j++) {
        NSString *dis = [FormatController formatDistance:_historyRecords[i].distance.floatValue];
        disArray[j] = dis;
        //NSLog(@"dis tanc e: %@",disArray[j]);
    }
    
    //Get date array
    for (int i= arraysize - 1, j = 0; i >= 0 ; i--, j++) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd"];
        [formatter stringFromDate:_historyRecords[i].timestamp];
        NSString *date = [formatter stringFromDate:_historyRecords[i].timestamp];
        dateArray[j] = date;
        //NSLog(@"Time DaTe: %@",dateArray[j]);
    }
    //  Run *runPastObject = _historyRecords[0];
    //   NSLog(@"Duration: %f", _historyRecords[0].duration.floatValue);
    //    NSLog(@"Distance: %f", _historyRecords[0].distance.floatValue);
    
    
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:dateArray];
    self.lineChart.showCoordinateAxis = YES;
    
    // added an examle to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.yGridLinesColor = [UIColor clearColor];
    self.lineChart.showYGridLines = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 1.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    [self.lineChart setYLabels:@[
                                 @"0 mi",
                                 @"0.25 mi",
                                 @"0.5 mi",
                                 @"0.75 mi",
                                 @"1 mi",
                                 ]
     ];
    
    // Line Chart #1
    NSArray * data01Array = disArray;
//    if (_historyRecords.count == 0) {
//        data01Array = @[];
//    } else {
//        data01Array = disArray;
//    }
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Runner";
    data01.color = PNFreshGreen;
    data01.alpha = 0.3f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
//    NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.dataTitle = @"Beta";
//    data02.color = PNTwitterColor;
//    data02.alpha = 0.5f;
//    data02.itemCount = data02Array.count;
//    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [data02Array[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    
    //self.lineChart.chartData = @[data01, data02];
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    
    [self.view addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
    [self.view addSubview:legend];

}

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
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
    [_lblFitbitBtn setTitle: @"Click to refresh" forState: UIControlStateNormal];
}
@end
