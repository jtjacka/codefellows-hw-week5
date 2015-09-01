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


@end