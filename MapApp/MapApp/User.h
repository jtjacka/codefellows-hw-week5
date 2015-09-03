//
//  User.h
//  MapApp
//
//  Created by Jeffrey Jacka on 8/31/15.
//  Copyright (c) 2015 Jeffrey Jacka. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface User : PFUser<PFSubclassing>

@property (strong, nonatomic) NSMutableArray *reminders;

@end