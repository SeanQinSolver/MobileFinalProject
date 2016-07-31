//
//  DetailRunViewController.m
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/28/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "DetailRunViewController.h"
#import <MapKit/MapKit.h>
#import "MathController.h"
#import "Run.h"
#import "Location.h"
#import "MultiColor.h"


@interface DetailRunViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailRunViewController

- (void)setRun:(Run *)run
{
    if (_currentRun != run) {
        _currentRun = run;
        //[self configureView];
    }
}

- (void)configureView
{
    self.distLabel.text = [MathController stringifyDistance:self.currentRun.distance.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.currentRun.timestamp];
    
    self.durLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.currentRun.duration.intValue usingLongFormat:YES]];
    
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.currentRun.distance.floatValue overTime:self.currentRun.duration.intValue]];
    
    [self loadMap];
}

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.currentRun.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.currentRun.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
    
    return region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    //Without color change
//    if ([overlay isKindOfClass:[MKPolyline class]]) {
//        MKPolyline *polyLine = (MKPolyline *)overlay;
//        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
//        aRenderer.strokeColor = [UIColor blackColor];
//        aRenderer.lineWidth = 3;
//        return aRenderer;
//    }
//    
//    return nil;
    
    if ([overlay isKindOfClass:[MultiColor class]]) {
        MultiColor *polyLine = (MultiColor *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 5;
        return aRenderer;
    }
    
    return nil;
    
}

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[self.currentRun.locations.count];
    
    for (int i = 0; i < self.currentRun.locations.count; i++) {
        Location *location = [self.currentRun.locations objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.currentRun.locations.count];
}

- (void)loadMap
{
//    int count = self.currentRun.locations.count;
//    NSLog(@"****Count location Number:%d",count);
    if (self.currentRun.locations.count > 0) {
        
        self.mapView.hidden = NO;
        
        // set the map bounds
        [self.mapView setRegion:[self mapRegion]];
        
        // make the line(s!) on the map
        //[self.mapView addOverlay:[self polyLine]];
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.currentRun.locations.array];
        [self.mapView addOverlays:colorSegmentArray];
        
    }
    
//    else {
//        
//        // no locations were found!
//        self.mapView.hidden = YES;
//        
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:@"Sorry, this run has no locations saved."
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
}

- (IBAction)shareTwtter:(id)sender {
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    NSString *s1 = [MathController stringifyDistance:self.currentRun.distance.floatValue];
    NSString *s2 = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.currentRun.distance.floatValue overTime:self.currentRun.duration.intValue]];
    NSString *result = [[[@"#RunRecipet, I did a good job today, my disntance is " stringByAppendingString:s1]stringByAppendingString:@" and my average page is "]stringByAppendingString:s2];
    
    [composer setText:result];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];
    [self configureView];
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
