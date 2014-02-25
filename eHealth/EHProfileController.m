//
//  EHProfileController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHProfileController.h"
#import "EHNetworkManager.h"
#import "EHAppDelegate.h"

@interface EHProfileController ()

@end

@implementation EHProfileController

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
    NSString * Account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];
    [[EHNetworkManager theManager] addObserver:self forKeyPath:@"responseDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    [[EHNetworkManager theManager] getUserDetails:Account];
	// Do any additional setup after loading the view.
    self.navigationController.topViewController.title = @"Profile";
    
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    self.usernameLabel.textColor =  mainColor;
    self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    
    self.dob.textColor =  mainColor;
    self.dob.font =  [UIFont fontWithName:fontName size:14.0f];
    
    self.ageLabel.textColor =  mainColor;
    self.ageLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    
    self.registerDateLabel.textColor =  mainColor;
    self.registerDateLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    
    
    self.cityLabel.textColor =  mainColor;
    self.cityLabel.font =  [UIFont fontWithName:fontName size:14.0f];
 
    
    self.stateLabel.textColor =  mainColor;
    self.stateLabel.font =  [UIFont fontWithName:fontName size:14.0f];

    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.profileImageView.layer.borderColor = imageBorderColor.CGColor;
    
    [self addDividerToView:self.scrollView atLocation:300];
    self.scrollView.contentSize = CGSizeMake(320, 590);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
}

-(void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

#pragma network manager observer methods

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (![object isKindOfClass:[EHNetworkManager class]])
        return;
    
    EHNetworkManager *manager = object;
    if ([manager.responseDictionary[@"service"]  isEqualToString:@"getUserData"])
    {
        if ([manager.responseDictionary[@"status"] isEqualToString:@"yes"]) {
            NSDictionary *responseData = manager.responseDictionary[@"data"];
            [self updateProfileData:responseData];
        } else {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:manager.responseDictionary[@"msg"]];
        }
    }
}

#pragma local methods 

-(void) updateProfileData:(NSDictionary *)responseData{
    NSString *FullName = responseData[@"first_name"];
    FullName = [FullName stringByAppendingString: @" "];
    FullName = [FullName stringByAppendingString: responseData[@"last_name"]];
    self.nameLabel.text = FullName;
    self.usernameLabel.text = responseData[@"email"];
    if (responseData[@"dob"])
        self.dob.text = [NSString stringWithFormat:@"DOB :%@",responseData[@"dob"]];
    if (responseData[@"register_date"])
        self.registerDateLabel.text = [NSString stringWithFormat:@"Registered Date: %@",responseData[@"register_date"]];
    if (responseData[@"city"])
        self.cityLabel.text = [NSString stringWithFormat:@"City : %@",responseData[@"city"]];
    if (responseData[@"state"])
        self.stateLabel.text = [NSString stringWithFormat:@"State : %@",responseData[@"state"]];
    if (responseData[@"age"])
        self.ageLabel.text = [NSString stringWithFormat:@"Age : %@",responseData[@"age"]];
    
  //  NSString *uPicture = @"http://www.centiva.co/newneuro/files/profile/";
    //TODO: add support for image
  //  self.profileImageView.image = [UIImage imageWithData: imageData];
    //self.profileImageView.image = [UIImage imageWithContentsOfFile:[]];
    //  if (responseData[@"user_image"])
   // uPicture = [uPicture stringByAppendingString:responseData[@"user_image"]];
    
}

@end
