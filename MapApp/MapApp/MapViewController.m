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
#import "Constants.h"
#import "Reminder.h"
#import "ParseService.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton1;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarButton2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton3;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
  
  [super viewDidLoad];
  
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderNotificationAdded:) name:kReminderNotication object:nil];
  
    
    if([PFUser currentUser]) {
        //Load Current Reminders for the User
        [ParseService queryForUserReminders:^(NSArray *reminders) {
            for (Reminder *reminder in reminders) {
                [self createRegion:reminder.location.longitude latitude:reminder.location.latitude regionName:reminder.name regionRadius:[reminder.radius floatValue]];
            }
        }];
    }

  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  //CLLocation Manager
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.desiredAccuracy = 10;
  
  [self.locationManager requestAlwaysAuthorization];
  [self.locationManager startUpdatingLocation];
  
  //Taken from Lecture
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 10, 10) animated:true];
  
  //Code Challenges
  [self codeChallenge];
  
}

-(void) viewDidAppear:(BOOL)animated {
    [self LogInStatus];
  if(![PFUser currentUser]) {
      [self showLoginView];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)refreshView {
    [self viewDidLoad];
}

-(void) showLoginView {
    if([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.delegate = self;
        [self presentViewController:logInViewController animated:YES completion:nil];
    } else if ([PFUser currentUser]) {
        [PFUser logOut];
        [self.mapView removeOverlays:self.mapView.overlays];
        [self LogInStatus];
        [self refreshView];
    } else {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.delegate = self;
        [self presentViewController:logInViewController animated:YES completion:nil];
    }
}

-(void)LogInStatus {
    //Add Tab Bar Item
    if([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        UIBarButtonItem *logIn = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginView)];
        self.navigationItem.rightBarButtonItem = logIn;
    } else if ([PFUser currentUser]) {
        UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginView)];
        self.navigationItem.rightBarButtonItem = logOut;
    } else {
        UIBarButtonItem *logIn = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginView)];
        self.navigationItem.rightBarButtonItem = logIn;
    }
}


#pragma mark - Regions

-(void)reminderNotificationAdded:(NSNotification *)notification {
  NSLog(@"Notification Fired!");
  
  Reminder *newReminder = notification.object;

  [self createRegion:newReminder.location.longitude latitude:newReminder.location.latitude regionName:newReminder.name regionRadius:[newReminder.radius floatValue]];
}

-(void)createRegion:(double)longitude latitude:(double)latitude regionName:(NSString *)regionName regionRadius:(float)radius {
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(latitude, longitude) radius:radius identifier:regionName];
    
    [self.locationManager startMonitoringForRegion:region];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) radius:radius];
    
    [self.mapView addOverlay:circle];
    
  }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
 
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  
  circleRenderer.strokeColor = [UIColor blueColor];
  circleRenderer.fillColor = [UIColor redColor];
  circleRenderer.alpha = 0.5;
  
  return circleRenderer;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"Region Entered");
  
  UILocalNotification *newNotification = [[UILocalNotification alloc]init];
  
  newNotification.alertTitle = @"Entered Region";
  newNotification.alertBody = @"You have entered a region with a reminder";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:newNotification];
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
    [self.mapView removeAnnotation:sender];
    destinationVC.pinLocation = sender.coordinate;
  }
  
}

#pragma mark - Parse
- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
    [self LogInStatus];
    [self refreshView];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self dismissViewControllerAnimated:YES completion:nil];
  [PFUser enableAutomaticUser];
}

#pragma mark - Code Challenge Tests

-(void)codeChallenge {
  CodeChallenge *tests = [[CodeChallenge alloc]init];
  
  //MARK: Monday
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
  
  //MARK: Tuesday
  BOOL isAnagram = [tests isAnagram:@"hamlet" secondString:@"amleth"];
  NSLog(@"String is an anagram? %s", isAnagram ? "true" : "false");
  //ternary... bitch
  
  //MARK: Wednesday
  int sum = [tests sumOfNumbersInString:@"J4e6f8f93"];
  NSLog(@"Sum from String: %d", sum);
  
  //MARK: Thursday - Node
  
  
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
