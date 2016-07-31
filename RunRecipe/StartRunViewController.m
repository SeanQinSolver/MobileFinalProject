//
//  StartRunViewController.m
//  RunRecipe
//
//  Created by QinShawn on 7/27/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "StartRunViewController.h"
#import "MathController.h"

@interface StartRunViewController () {
    int timeCount;
    float dist;
    //NSMutableArray<id<MKOverlay>> *overlayArray;
    User *currUser;
    
}

@end

@implementation StartRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
    
    NSLog(@"Enter run");
    _mapView.delegate = self;
    _startBtn.enabled = TRUE;
    _abortBtn.enabled = FALSE;
    _stopBtn.enabled = FALSE;
    _distLabel.hidden = YES;
    _paceLabel.hidden = YES;
    _durLabel.hidden = YES;
    _distLabel.text = @"0.00";
    _paceLabel.text = @"0.00";
    _durLabel.text = @"0.00";
    
    /*Store user into database*/
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext: _managedObjectContext];
    TWTRSession *session = [[[Twitter sharedInstance]sessionStore]session];
    
    user.name = [session userName];
    user.userid = @([[session userID] intValue]);
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [session userName]];
    [request setPredicate:predicate];
    NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
    if (result.count == 0) {
        NSManagedObjectContext *context = _managedObjectContext;
        if (![context save:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillAppear:(BOOL)animated {
    _startBtn.hidden = NO;
    _stopBtn.hidden = NO;
    _distLabel.hidden = YES;
    _paceLabel.hidden = YES;
    _durLabel.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startRun:(id)sender {
    
    [_mapView removeOverlays:self.mapView.overlays];
    
     NSLog(@"started");
    
    _startBtn.enabled = FALSE;
    _stopBtn.enabled = TRUE;
    _abortBtn.enabled = TRUE;
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(count) userInfo:nil repeats:YES];
    
    timeCount = 0;
    dist = 0;
    _locationRecords = [[NSMutableArray alloc]init];
    
    [self updateLocations];
    _distLabel.hidden = NO;
    _paceLabel.hidden = NO;
    _durLabel.hidden = NO;
}

-(void)count {
    timeCount++;
    //NSLog(@"time is : %d" , timeCount);
    [self refresh];
    [self updateProgressImageView];
}

- (void)updateProgressImageView
{
    int currentPosition = self.progressImageView.frame.origin.x;
    CGRect newRect = self.progressImageView.frame;
    
    switch (currentPosition) {
        case 20:
        newRect.origin.x = 80;
        break;
        case 80:
        newRect.origin.x = 140;
        break;
        default:
        newRect.origin.x = 20;
        break;
    }
    
    self.progressImageView.frame = newRect;
}


-(void)refresh {
//    _durLabel.text = [NSString stringWithFormat:@"%d", timeCount];;
//    _distLabel.text = [NSString stringWithFormat:@"%.2f", dist];
//    float pace = dist / timeCount;
//    _paceLabel.text = [NSString stringWithFormat:@"%.2f", pace];
    //NSLog(@"dist label: %f", dist);
    
    self.durLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:timeCount usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@", [MathController stringifyDistance:dist]];
    NSString *countLen = [MathController stringifyDistance:dist];
    NSUInteger length = [countLen length];
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: _distLabel.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(10, length)];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont systemFontOfSize:25]
                 range:NSMakeRange(10, length)];
    [_distLabel setAttributedText: text];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:dist overTime:timeCount]];
}


-(void)updateLocations {
    NSLog(@"Start update location");
    if (_locManager == nil) {
        _locManager = [[CLLocationManager alloc]init];
    }
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locManager.activityType = CLActivityTypeFitness;
    
    _locManager.distanceFilter = 10;
    
    if ([_locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locManager requestWhenInUseAuthorization];
    }
    NSLog(@"in to update");
    [_locManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
   
    
    for (CLLocation *loc in locations) {
        
        NSTimeInterval interval = [loc.timestamp timeIntervalSinceNow];
        
        if (fabs(interval) < 10.0 && loc.horizontalAccuracy < 20) {
            //NSLog(@"jinlai");
            // update distance
            if (_locationRecords.count > 0) {
                dist += [loc distanceFromLocation:_locationRecords.lastObject];
            
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)_locationRecords.lastObject).coordinate;
                coords[1] = loc.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(loc.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [_locationRecords addObject:loc];
        }
    
    }

}

#pragma mark - MKMapViewDelegate-draw map

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        render.strokeColor = [UIColor purpleColor];
        render.lineWidth = 5;
        //[overlayArray addObject:render];
        return render;
    }
    return nil;
}


//save
- (IBAction)stopRun:(id)sender {
    NSLog(@"saved");
    _startBtn.enabled = TRUE;
    _stopBtn.enabled = FALSE;
    _abortBtn.enabled = FALSE;
    [_timer invalidate];
    [_locManager stopUpdatingLocation];
    [self saveRunObject];
    [_locationRecords removeAllObjects];
    [self performSegueWithIdentifier:@"newRunDetail" sender:nil];

    
}


-(void)saveRunObject {
    NSLog(@"get!!");
    Run *runObject = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext: self.managedObjectContext];
    runObject.duration = [NSNumber numberWithInt:timeCount];
    runObject.distance = [NSNumber numberWithFloat:dist];
    runObject.timestamp = [NSDate date];
    
    /*Store the user object for each run*/
    
    runObject.user = currUser;
    
    
    NSMutableArray *locationPointArray = [[NSMutableArray alloc]init];
    
    for (CLLocation *loc in _locationRecords) {
        Location *newPoint = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
        newPoint.latitude = [NSNumber numberWithDouble:loc.coordinate.latitude];
        newPoint.longitude = [NSNumber numberWithDouble:loc.coordinate.longitude];
        [locationPointArray addObject:newPoint];
    }
    
    runObject.locations = [NSOrderedSet orderedSetWithArray:locationPointArray];
    

    _currentRun = runObject;
    
    NSError *error = nil;
    NSManagedObjectContext *context = _managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"Error: %@", error);
    }
}

//abort current run

- (IBAction)abortRun:(id)sender {
    NSLog(@"aborted");
    _startBtn.enabled = TRUE;
    _stopBtn.enabled = FALSE;
    [_timer invalidate];
    [_locManager stopUpdatingLocation];
    
    timeCount = 0;
    dist = 0;
    _durLabel.text= @"";
    _distLabel.text = @"";
    _paceLabel.text = @"";
    [_mapView removeOverlays:self.mapView.overlays];

    [_locationRecords removeAllObjects];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        int count = self.currentRun.locations.count;
        NSLog(@"****Count location Number:%d",count);
        [[segue destinationViewController] setRun:self.currentRun];
}
@end
