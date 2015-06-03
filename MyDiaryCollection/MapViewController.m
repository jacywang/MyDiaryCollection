//
//  MapViewController.m
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-03.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MapViewController.h"
#import "Diary.h"
#import "DiaryDetailViewController.h"


@interface MapViewController ()

@property (nonatomic, assign) BOOL isInitialLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSMutableArray *diaryCollection;

@property (nonatomic, strong) NSMutableArray *selectedDiaryCollection;

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDiaryDetailFromMap"]) {
        DiaryDetailViewController *diaryDetailViewController = (DiaryDetailViewController *)segue.destinationViewController;
        Diary *selectedDiary = self.selectedDiaryCollection[[[self.diaryTableView indexPathForSelectedRow] row]];
        diaryDetailViewController.diary = selectedDiary;
    }
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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[[view annotation] coordinate].latitude longitude:[[view annotation] coordinate].longitude];
    
    self.selectedDiaryCollection = [[NSMutableArray alloc] init];
    
    NSLog(@"annotation latitude: %f", [[view annotation] coordinate].latitude);
    NSLog(@"point latitude: %f", point.latitude);
    
    for (Diary *diary in self.diaryCollection) {
        NSLog(@"point latitude: %f", point.latitude);
        NSLog(@"point longitude: %f", point.longitude);
        NSLog(@"diary location latitude: %f", diary.location.latitude);
        NSLog(@"diary location longitude: %f", diary.location.longitude);
        if (diary.location.latitude == point.latitude && diary.location.longitude == point.longitude) {
            [self.selectedDiaryCollection addObject:diary];
        }
    }
    
    [self.diaryTableView reloadData];
}

#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedDiaryCollection.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Diary *diary = self.selectedDiaryCollection[indexPath.row];
    
    PFFile *imageFile = diary[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            cell.imageView.image = [UIImage imageWithData:data];
            
        }
        
    }];
    
    NSDate *date = [diary valueForKey:@"createdAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    
    cell.textLabel.text = dateString;
    
    PFGeoPoint *point = [diary valueForKey:@"location"];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    [geocode reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        cell.detailTextLabel.text = placemark.name;
        
    }];

    return cell;
}

@end
