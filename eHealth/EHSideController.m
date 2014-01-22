//
//  EHSideController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/19/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHSideController.h"
#import "EHViewController.h"

@interface EHSideController ()

@property (nonatomic, weak) IBOutlet UILabel* profileNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* profileLocationLabel;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@end

@implementation EHSideController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationController.topViewController.navigationController.navigationBarHidden = NO;
    self.navigationController.topViewController.title = @"Selector";
    self.navigationController.topViewController.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    UIColor* mainColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    
    self.view.backgroundColor = darkColor;
    self.tableView.backgroundColor = darkColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSString* fontName = @"Avenir-Black";
    NSString* boldFontName = @"Avenir-BlackOblique";
    
    self.profileNameLabel.textColor = [UIColor whiteColor];
    self.profileNameLabel.font = [UIFont fontWithName:fontName size:14.0f];
    self.profileNameLabel.text = @"Lena Llellywyngot";
    
    self.profileLocationLabel.textColor = mainColor;
    self.profileLocationLabel.font = [UIFont fontWithName:boldFontName size:12.0f];
    self.profileLocationLabel.text = @"London, UK";
    
    self.profileImageView.image = [UIImage imageNamed:@"profile-1.jpg"];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    
    NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"Inbox", @"7", @"envelope" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"Updates", @"7", @"check" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object3 = [NSDictionary dictionaryWithObjects:@[ @"Profile", @"0", @"user" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object4 = [NSDictionary dictionaryWithObjects:@[ @"Create Event", @"0", @"account" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object5 = [NSDictionary dictionaryWithObjects:@[ @"Settings", @"0", @"settings" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object6 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"count", @"icon" ]];
    
    self.items = @[object1, object2, object3, object4, object5, object6];
	
}


#pragma mark SFSlideMenuDataSource

-(NSIndexPath*) selectedIndexPath{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath{
    
    NSString *segueID;
    
    switch (indexPath.row) {
        case 0:
            segueID = @"Inbox";
            break;
        case 1:
            segueID = @"slider";

            break;
        case 2:
            segueID = @"profile";

            break;
        case 3:
            segueID = @"createEvent";

            break;
        case 4:
            segueID = @"settings";

            break;
        case 5:
            segueID = @"slider";

            break;
            
        default:
            segueID = @"slider";
            break;
    }
    return segueID;
}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    //if (indexPath.row ==0) {
    //    return YES;
    // }
    return NO;
}

-(void) configureMenuButton:(UIButton *)menuButton{
    menuButton.frame = CGRectMake(0, 0, 40, 29);
    [menuButton setImage:[UIImage imageNamed:@"menuicon"] forState:UIControlStateNormal];
}

-(void) configureSlideLayer:(CALayer *)layer{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.3;
    layer.shadowOffset = CGSizeMake(-5, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
}

-(CGFloat) leftMenuVisibleWidth{
    return 280;
}

-(void) prepareForSwitchToContentViewController:(UINavigationController *)content{
 
    UIViewController* controller = [content.viewControllers objectAtIndex:0];
    if ([controller isKindOfClass:[EHViewController class]]) {
        EHViewController* mainViewController = (EHViewController*)controller;
        mainViewController.menuViewController = self;
    }
}


#pragma mark SFSlideMenuDelegate

-(void) slideMenuWillSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideIn");
}
-(void) slideMenuDidSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideIn");
}
-(void) slideMenuWillSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToSide");
}
-(void) slideMenuDidSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToSide");
}
-(void) slideMenuWillSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideOut");
}
-(void) slideMenuDidSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideOut");
}
-(void) slideMenuWillSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToLeft");
}
-(void) slideMenuDidSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToLeft");
}



@end
