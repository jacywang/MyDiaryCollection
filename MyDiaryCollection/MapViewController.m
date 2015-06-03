//
//  MapViewController.m
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-03.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MapViewController.h"
#import "Diary.h"


@interface MapViewController ()
@property (nonatomic, assign) BOOL isInitialLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSMutableArray *diaryCollection;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isInitialLocation = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 50;
    self.locationManager.distanceFilter = 50;
    
    self.currentLocation = [[CLLocation alloc] init];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Diary"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"userID" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
        }
        else {
            self.diaryCollection = [NSMutableArray arrayWithArray:objects];
            [self addAnnotationView];
        }
    }];
}

-(void)addAnnotationView {
    
    for (Diary *diary in self.diaryCollection) {
        
        PFGeoPoint *point = [diary valueForKey:@"location"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        
        MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
        marker.coordinate = CLLocationCoordinate2DMake(diary.location.latitude, diary.location.longitude);
        
        CLGeocoder *geocode = [[CLGeocoder alloc] init];
        [geocode reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks firstObject];
            [marker setTitle: placemark.name];
            [self.mapView addAnnotation:marker];
        }];
        

    }
}


#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
    
    if(!self.isInitialLocation) {
        
        MKCoordinateRegion startingRegion;
        CLLocationCoordinate2D loc = self.currentLocation.coordinate;
        startingRegion.center = loc;
        startingRegion.span.latitudeDelta = 0.02;
        startingRegion.span.longitudeDelta = 0.02;
        [self.mapView setRegion:startingRegion];
        
        self.isInitialLocation = YES;
        
    }
    
}

#pragma mark - MKMapView Delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    static NSString *annotationIdentifier = @"diaryLocation";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.calloutOffset = CGPointMake(-7, 0);
    
    return pinView;
}



#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return nil;
    
}

@end