//
//  CodeChallenge.h
//  MapApp
//
//  Created by Jeffrey Jacka on 9/1/15.
//  Copyright (c) 2015 Jeffrey Jacka. All rights reserved.
//

@interface CodeChallenge : NSObject

-(void)AddToStack:(id)newObject;
-(id)RemoveFromStack;
-(void)AddToQueue:(id)newObject;
-(id)RemoveFromQueue;
-(void)printStack;
-(void)printQueue;
-(BOOL)isAnagram:(NSString *)firstString secondString:(NSString *)secondString;
-(int)sumOfNumbersInString:(NSString *)stringToSum;

@end
