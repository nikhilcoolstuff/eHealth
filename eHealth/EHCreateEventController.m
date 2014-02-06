//
//  EHCreateEventController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHCreateEventController.h"
#import "EHNetworkManager.h"

@interface EHCreateEventController ()
{
    NSMutableArray *mySymptoms;
    NSMutableArray *myLevels;
    UIColor* mainColor;
    NSArray* responseDictionaryAllsymptoms;
    NSArray* responseDictionaryAllpains;
}
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
    // mySymptoms = [NSMutableArray arrayWithObjects: @"Apple", @"Oranges", @"Grapes", @"xyzzz", nil];
    
    self.symptomsTableView.delegate = self;
    self.symptomsTableView.dataSource = self;
    self.symptomsTableView.tag=1;
    
    self.levelsTableView.delegate=self;
    self.levelsTableView.dataSource=self;
    self.levelsTableView.tag=2;
    
    NSData * allsymptoms = [[EHNetworkManager theManager] getAllSymptoms];
    //     NSString *responseString = [[NSString alloc] initWithData:allsymptoms encoding:NSUTF8StringEncoding];
    
    NSError* errorSymtomps;
    responseDictionaryAllsymptoms = [NSJSONSerialization
                                     JSONObjectWithData:allsymptoms
                                     options:kNilOptions
                                     error:&errorSymtomps];
    mySymptoms = [NSMutableArray arrayWithArray:[responseDictionaryAllsymptoms valueForKey:@"sym_title"]];
    
    //    for (NSDictionary *avatar in responseDictionaryAllsymptoms) {
    //       mySymptoms set: avatar[@"sym_title"]];
    //      //  NSString *name = avatar[@"name"];
    //
    //        // THE REST OF YOUR CODE
    //    }
    //  mySymptoms = [responseDictionaryAllsymptoms allValues];
    //    for (NSDictionary *key in responseDictionaryAllsymptoms) {
    //      //  [mySymptoms addObject:key[@"sym_title"]];
    //   //     NSLog(@"sym Key : %@",key[@"sym_title"]);
    //    }
    //    for (int i=0;i<[responseDictionaryAllsymptoms count];i++) // object is your root NSDictionary
    //    {
    //
    //  }
    //  mySymptoms = [NSMutableArray arrayWithObjects: responseDictionaryAllsymptoms[@"sym_title"], nil];
    
    
    //Code for pulling all pains
    NSData * allpains = [[EHNetworkManager theManager] getAllPains];
    //  NSString *responseString = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
    
    NSError* errorPains;
    responseDictionaryAllpains = [NSJSONSerialization
                                  JSONObjectWithData:allpains
                                  options:kNilOptions
                                  error:&errorPains];
    myLevels = [NSMutableArray arrayWithArray:[responseDictionaryAllpains valueForKey:@"level_title"]];
    
    mainColor = [UIColor colorWithRed:51.0/255 green:204.0/255 blue:255 alpha:1.0f];
    
	// Do any additional setup after loading the view.
    self.navigationController.topViewController.title = @"Create Event";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableview function

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    if(tableView.tag==1)
    {
        cell.textLabel.text = [mySymptoms objectAtIndex: indexPath.row]; //[NSString stringWithFormat:@"%d",indexPath.row];
    }
    else
    {
        cell.textLabel.text = [myLevels objectAtIndex: indexPath.row]; //[NSString stringWithFormat:@"%d",indexPath.row];
    }
    //    if (indexPath.row % 2 == 0) {
    //        cell.backgroundColor = mainColor;
    //    }
    
    return cell;
}
// code to set height of each data row
/*-(CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 20;
 }*/

//creating number of rows in each section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"tttt %lu",(unsigned long)[mySymptoms count]);
    return [mySymptoms count];
}

// creating no of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  NSLog(@"sdfgsdgsdgsgsdg %@",tableView);
    return 1;
}
// code to enter section title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    tableView.backgroundColor = mainColor;
    
    if(tableView.tag==1) {
        return   [NSString stringWithFormat:@"Symptoms : "];
    }
    else
    {
        return   [NSString stringWithFormat:@"Levels : "];
        
    }
    
}

// alternative way to pass section title
/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 
 UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
 tempView.backgroundColor=[UIColor blackColor];
 
 UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
 tempLabel.backgroundColor=[UIColor greenColor];
 tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
 tempLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
 tempLabel.font = [UIFont boldSystemFontOfSize:20];
 
 if(section==0)
 {
 tempLabel.text=@"Colors : ";    }
 else
 {
 
 tempLabel.text=@"Fruits : ";
 }
 
 [tempView addSubview:tempLabel];
 
 return tempView;
 }*/
// code to set height of section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
// code to check which row is clicked
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Row clicked :-- %d",indexPath.row);
}

@end
