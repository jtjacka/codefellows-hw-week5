//
//  User.m
//  
//
//  Created by Jeffrey Jacka on 8/31/15.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User

@dynamic reminders;

+ (void)load {
  [self registerSubclass];
}

@end

