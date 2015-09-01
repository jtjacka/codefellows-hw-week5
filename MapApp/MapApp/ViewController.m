//
//  ViewController.m
//  MapApp
//
//  Created by Jeffrey Jacka on 8/31/15.
//  Copyright (c) 2015 Jeffrey Jacka. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@property (copy, nonatomic) void(^myBlock)(NSString *);

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.myBlock = ^void(NSString *name) {
    
  };
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
