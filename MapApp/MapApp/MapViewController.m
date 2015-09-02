//
//  MapViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/1/15.
//
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton1;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarButton2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton3;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    
    //CLLocation Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 10;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
  
    //Taken from Lecture
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 10, 10) animated:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftBarButton:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.444913, -121.426391), 100, 100) animated:true];
}

- (IBAction)middleBarButton:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(48.861677, -121.678886), 100, 100) animated:true];
}

- (IBAction)rightBarButton:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(43.589153, -110.827879), 100, 100) animated:true];
}

- (IBAction)longGestureRecognizerAction:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateEnded) {
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
    newPoint.coordinate = touchMapCoordinate;
    newPoint.title = @"New Point!";
    
    [self.mapView addAnnotation:newPoint];
    
  } else {
    return;
  }
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

#pragma mark - Map View Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  //Ignore For Current User Location
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  //Add View to Annotation
  MKAnnotationView *newAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  newAnnotationView.annotation = annotation;
  
  if(!newAnnotationView) {
    newAnnotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnootationView"];
  }
  
  newAnnotationView.canShowCallout = true;
  UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  newAnnotationView.rightCalloutAccessoryView = rightCallout;
  
  //Add Segue to Button
  [rightCallout addTarget:self action:@selector(rightCalloutAction) forControlEvents:UIControlEventTouchUpInside];
  
  
  return newAnnotationView;
}

#pragma mark - Perform Segue From Callout
-(void)rightCalloutAction{
  [self performSegueWithIdentifier:@"ShowReminderDetail" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
