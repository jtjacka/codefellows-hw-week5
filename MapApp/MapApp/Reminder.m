//
//  Reminder.m
//  
//
//  Created by Jeffrey Jacka on 9/3/15.
//
//

#import <Foundation/Foundation.h>
#import "Reminder.h"
#import <Parse/PFObject+Subclass.h>

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic parent;
@dynamic radius;

+ (void)load {
  [self registerSubclass];
}

+ (NSString *)parseClassName {
  return @"Reminder";
}
@end