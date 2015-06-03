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

#pragma mark - LocationDelegate

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



#pragma mark - TableViewDataSource

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
