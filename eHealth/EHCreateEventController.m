//
//  EHCreateEventController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHCreateEventController.h"
#import "EHNetworkManager.h"
#import "EHAppDelegate.h"

@interface EHCreateEventController ()
{
    NSMutableArray *mySymptoms;
    NSMutableArray *myLevels;
    UIColor* mainColor;

}

@property (assign, nonatomic) CGSize keyboardSize;

@end

@implementation EHCreateEventController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenScrollView.contentSize = CGSizeMake(320, 350);
    self.screenScrollView.delegate = self;
    self.symptomsTableView.delegate = self;
    self.symptomsTableView.dataSource = self;
    self.painLevelTextView.delegate = self;
    self.painLevelTextView.tag = 1;
    self.levelsPickerView.delegate=self;
    self.levelsPickerView.dataSource=self;
    self.levelsPickerView.hidden = YES;
    self.extraDetailsTextView.delegate = self;
    self.extraDetailsTextView.tag = 2;
    mySymptoms = [NSMutableArray new];
    myLevels = [NSMutableArray new];
    [[EHNetworkManager theManager] addObserver:self forKeyPath:@"responseDictionary" options:NSKeyValueObservingOptionNew context:NULL];

    [[EHNetworkManager theManager] getAllSymptomEvents];
    [[EHNetworkManager theManager] getAllPainLevels];
    
    mainColor = [UIColor colorWithRed:51.0/255 green:204.0/255 blue:255 alpha:1.0f];
    self.painLevelTextView.inputView = self.levelsPickerView;
    self.navigationController.topViewController.title = @"Create Event";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.eventDescTextView becomeFirstResponder];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

    [self.eventDescTextView resignFirstResponder];
    [self.extraDetailsTextView resignFirstResponder];
}

- (IBAction)createEvent:(id)sender {

    [self.eventDescTextView resignFirstResponder];
    [self.extraDetailsTextView resignFirstResponder];
    //TODO call webservice to create the event.
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];

    [[EHNetworkManager theManager] addanEventforUser:account description:self.eventDescTextView.text additionalComments:self.extraDetailsTextView.text withpainLevel:@"1" andSymptoms:[NSArray arrayWithObject:@"1"]];
}

#pragma tableview datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    NSDictionary *symptomDictionary = mySymptoms[indexPath.row];
    if (symptomDictionary[@"sym_title"]) {
        cell.textLabel.text = symptomDictionary[@"sym_title"];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"MyraidPro-Regular" size:8.0];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mySymptoms.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return myLevels.count;;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSDictionary *painLevels = myLevels[row];
    if (painLevels[@"level_title"]) {
        return painLevels[@"level_title"];
    } else {
        return nil;
    }
}

#pragma pickerview delegate 
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *painLevels = myLevels[row];
    if (painLevels[@"level_title"])
        self.painLevelTextView.text = painLevels[@"level_title"];
}

#pragma textview delegate 

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 1)
        return NO;
    else
        return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if (textView.tag == 1)
        self.levelsPickerView.hidden = NO;
    else
        [self.screenScrollView scrollRectToVisible:CGRectMake(self.screenScrollView.contentSize.width - 1,self.screenScrollView.contentSize.height - 1, 1, 1) animated:YES];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 1)
        self.levelsPickerView.hidden = YES;
}

#pragma network manager observer methods

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (![object isKindOfClass:[EHNetworkManager class]])
        return;
    
    EHNetworkManager *manager = object;
    if ([manager.responseDictionary[@"service"] isEqualToString:@"getAllSymptoms"]) {
        mySymptoms = [NSMutableArray arrayWithArray:manager.responseDictionary[@"data"]];
        [self.symptomsTableView reloadData];
    } else if([manager.responseDictionary[@"service"]  isEqualToString:@"getLevelOfPain"]) {
        myLevels = [NSMutableArray arrayWithArray:manager.responseDictionary[@"data"]];
        [self.levelsPickerView reloadAllComponents];
    } else if ([manager.responseDictionary[@"service"] isEqualToString:@"addEvent"]){
        if ([manager.responseDictionary[@"status"] isEqualToString:@"yes"]) {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Success" message:@"Event Added successfully"];
        } else {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:@"Error adding event"];
        }
    }
}


#pragma keyboard observer methods

- (void)keyboardWillShow:(NSNotification *)notification {

    self.screenScrollView.contentSize = CGSizeMake(320, 350);

    NSDictionary *keyboardInfo = notification.userInfo;
    self.keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    self.screenScrollView.contentSize = CGSizeMake(self.screenScrollView.contentSize.width, self.screenScrollView.contentSize.height + self.keyboardSize.width);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.screenScrollView.contentSize = CGSizeMake(320, 350);
}

@end
