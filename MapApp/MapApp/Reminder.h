//
//  Reminder.h
//  MapApp
//
//  Created by Jeffrey Jacka on 9/3/15.
//  Copyright (c) 2015 Jeffrey Jacka. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import <CoreLocation/CoreLocation.h>

@interface Reminder : PFObject<PFSubclassing>

@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) User *parent;
@property (strong, nonatomic) NSNumber *radius;

@end