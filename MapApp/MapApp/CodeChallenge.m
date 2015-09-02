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


@end