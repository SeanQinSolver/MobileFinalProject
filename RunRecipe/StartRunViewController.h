//
//  StartRunViewController.h
//  RunRecipe
//
//  Created by QinShawn on 7/27/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Run.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import <TwitterKit/TwitterKit.h>


@interface StartRunViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet MKMapView *progressImageView;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *abortBtn;


@property (nonatomic, strong) Run *currentRun;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *locationRecords;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CLLocationManager *locManager;

- (IBAction)shareTwtter:(id)sender;
- (IBAction)startRun:(id)sender;
- (IBAction)stopRun:(id)sender;
- (IBAction)abortRun:(id)sender;

@end
