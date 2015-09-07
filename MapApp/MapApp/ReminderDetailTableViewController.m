//
//  ReminderDetailTableViewController.m
//
//
//  Created by Jeffrey Jacka on 9/3/15.
//
//

#import "ReminderDetailTableViewController.h"
#import "Reminder.h"
#import "User.h"
#import "Constants.h"

@interface ReminderDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;

@end

@implementation ReminderDetailTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.delegate = self;
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
  // Return the number of rows in the section.
  return 1;
}

- (IBAction)changeRadiusSlider:(UISlider *)sender {
  self.radiusLabel.text = [NSString stringWithFormat:@"%.01f M", sender.value];
}

- (IBAction)saveAction:(id)sender {
  Reminder *newReminder = [[Reminder alloc] init];
  
  newReminder.location = [PFGeoPoint geoPointWithLatitude:self.pinLocation.latitude longitude:self.pinLocation.longitude];
  newReminder.name = self.nameTextField.text;
  newReminder.radius = [NSNumber numberWithFloat:self.radiusSlider.value];
  
  User *currentUser = (User *)[PFUser currentUser];
  
  [newReminder setObject:currentUser forKey:@"parent"];
  [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    NSLog(@"Save reminder %d",succeeded);
  }];
  
  [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];


  [[NSNotificationCenter defaultCenter] postNotificationName:kReminderNotication object:newReminder];
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
