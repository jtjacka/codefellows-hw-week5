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
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ReminderDetailTableViewController.h"
#import "CodeChallenge.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate>

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
    
    #pragma mark - Code Challenge Tests
    CodeChallenge *tests = [[CodeChallenge alloc]init];
    
    //Monday
    [tests AddToQueue:@"test1"];
    [tests AddToQueue:@"test2"];
    [tests printStack];
    NSString *removedFromQueue = [tests RemoveFromQueue];
    NSLog(@"removed from queue: %@",removedFromQueue);
    
    [tests AddToStack:@"test1"];
    [tests AddToStack:@"test2"];
    [tests printStack];
    NSString *removedFromStack = [tests RemoveFromStack];
    NSLog(@"removed from stack: %@",removedFromStack);
    
    //Tuesday
    BOOL isAnagram = [tests isAnagram:@"hamlet" secondString:@"amleth"];
    NSLog(@"String is an anagram? %s", isAnagram ? "true" : "false");
    //ternary... bitch
    
    //Wednesday
    int sum = [tests sumOfNumbersInString:@"J4e6f8f93"];


}

-(void) viewDidAppear:(BOOL)animated {
  //Parse Login
  if(![PFUser currentUser]) {
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
  }
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

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self dismissViewControllerAnimated:YES completion:nil];
  [PFUser enableAutomaticUser];
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
  MKPinAnnotationView *newAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  newAnnotationView.annotation = annotation;
  
  if(!newAnnotationView) {
    newAnnotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnootationView"];
  }
  
  newAnnotationView.canShowCallout = true;
  UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  newAnnotationView.rightCalloutAccessoryView = rightCallout;
  
  return newAnnotationView;
}

#pragma mark - Perform Segue From Callout
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  [self performSegueWithIdentifier:@"ShowReminderDetail" sender:view.annotation];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKPointAnnotation *)sender {
  if ([segue.identifier  isEqualToString: @"ShowReminderDetail"]) {
    ReminderDetailTableViewController *destinationVC = segue.destinationViewController;
    destinationVC.pinLocation = sender.coordinate;
  }
  
}





@end
