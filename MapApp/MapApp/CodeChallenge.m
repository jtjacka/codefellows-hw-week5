//
//  CodeChallenge.m
//  
//
//  Created by Jeffrey Jacka on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import "CodeChallenge.h"

@interface CodeChallenge()

@property (strong, nonatomic) NSMutableArray *stackArray;
@property (strong, nonatomic) NSMutableArray *queueArray;

@end

@implementation CodeChallenge

-(id)init {
    self = [super init];
    if(self) {
        self.stackArray = [[NSMutableArray alloc] init];
        self.queueArray = [[NSMutableArray alloc]init];
    }
    return self;
}

//MARK: Monday - Stack
-(void)AddToStack:(id)newObject {
  
  [_stackArray addObject:newObject];
  
}

-(id)RemoveFromStack{
  id tempObject;
  tempObject = _stackArray.firstObject;
  [_stackArray removeObjectAtIndex:0];
  return tempObject;
}

-(void)printStack {
    for (int i = 0; i < self.stackArray.count; i++){
        NSLog(@"%d element %@", i, self.stackArray[i]);
    }
}

//MARK: Monday - Queue
-(void)AddToQueue:(id)newObject {
  
  [_stackArray addObject:newObject];
  
}

-(id)RemoveFromQueue{
  id tempObject;
  tempObject = _stackArray.lastObject;
  [_stackArray removeLastObject];
  return tempObject;
}

-(void)printQueue {
    for (int i = 0; i < self.queueArray.count; i++){
        NSLog(@"%d element %@", i, self.queueArray[i]);
    }
}

//MARK: Tuesday
-(BOOL)isAnagram:(NSString *)firstString secondString:(NSString *)secondString {
  
  if (firstString.length != secondString.length)
    return false;
  
  NSCountedSet *firstSet = [[NSCountedSet alloc]init];
  NSCountedSet *secondSet = [[NSCountedSet alloc]init];
  
  for (int i = 0; i < firstString.length; i++){
    [firstSet addObject:@([firstString characterAtIndex:i])];
    [secondSet addObject:@([secondString characterAtIndex:i])];
  }
  
  return [firstSet isEqual:secondSet];
}

//MARK: Wednesday
-(int)sumOfNumbersInString:(NSString *)stringToSum {
    NSCharacterSet *numberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *removedChar = [[stringToSum componentsSeparatedByCharactersInSet:numberSet]componentsJoinedByString:@""];
    
    int sum = 0;
    
    for (int i = 0; i < removedChar.length ; i++) {
        sum += [[removedChar substringWithRange:NSMakeRange(i,1 )] intValue];
    }
    
    return sum;
}

//MARK: Thursday - Data Structure




@end