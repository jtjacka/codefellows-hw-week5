//
//  ParseService.m
//  MapApp
//
//  Created by Jeff Jacka on 9/6/15.
//  Copyright (c) 2015 Jeffrey Jacka. All rights reserved.
//

#import "ParseService.h"
#import <Parse/Parse.h>
#import "Reminder.h"

@implementation ParseService

+(void)queryForUserReminders {
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query whereKey:@"parent" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //call completion handler
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+(void)saveReminderToParse:(Reminder *)reminder {
    
}

@end
