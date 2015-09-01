//
//  MapViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/1/15.
//
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton1;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarButton2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton3;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
