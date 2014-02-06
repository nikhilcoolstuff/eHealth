//
//  EHProfileController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHProfileController.h"
#import "EHNetworkManager.h"
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
    //    NSData * userData = [self getUserData];
    NSData * userData = [[EHNetworkManager theManager] getUserDetails:2];
    //  NSString *responseString = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* responseDictionary = [NSJSONSerialization
                                        JSONObjectWithData:userData
                                        options:kNilOptions
                                        error:&error];
    //   NSLog(@"USER DATA BY AMIT IS : %@",responseString);
	// Do any additional setup after loading the view.
    self.navigationController.topViewController.title = @"Profile";
    
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    NSString *s = responseDictionary[@"first_name"];
    s = [s stringByAppendingString: @" "];
    s = [s stringByAppendingString: responseDictionary[@"last_name"]];
    self.nameLabel.text = s;
    
    self.usernameLabel.textColor =  mainColor;
    self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.usernameLabel.text = responseDictionary[@"email"];
    
    self.dob.textColor =  mainColor;
    self.dob.font =  [UIFont fontWithName:fontName size:14.0f];
    self.dob.text = [@"DOB : " stringByAppendingString:responseDictionary[@"dob"]];
    
    self.ageLabel.textColor =  mainColor;
    self.ageLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    //    self.ageLabel.text = responseDictionary[@"age"];
    self.ageLabel.text = @"Age Label here";
    
    self.registerDateLabel.textColor =  mainColor;
    self.registerDateLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.registerDateLabel.text = [@"Registered Date : " stringByAppendingString:responseDictionary[@"register_date"]];
    
    self.cityLabel.textColor =  mainColor;
    self.cityLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.cityLabel.text = [@"City : " stringByAppendingString:responseDictionary[@"city"]];
    
    self.stateLabel.textColor =  mainColor;
    self.stateLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.stateLabel.text = [@"State : " stringByAppendingString:responseDictionary[@"state"]];
    
    //    UIFont* countLabelFont = [UIFont fontWithName:boldItalicFontName size:20.0f];
    //    UIColor* countColor = mainColor;
    
    //    self.followerCountLabel.textColor =  countColor;
    //    self.followerCountLabel.font =  countLabelFont;
    //    self.followerCountLabel.text = @"22";
    //
    //    self.followingCountLabel.textColor =  countColor;
    //    self.followingCountLabel.font =  countLabelFont;
    //    self.followingCountLabel.text = @"15";
    //
    //    self.updateCountLabel.textColor =  countColor;
    //    self.updateCountLabel.font =  countLabelFont;
    //    self.updateCountLabel.text = @"30";
    
    //    UIFont* socialFont = [UIFont fontWithName:boldItalicFontName size:10.0f];
    //
    //    self.followerLabel.textColor =  mainColor;
    //    self.followerLabel.font =  socialFont;
    //    self.followerLabel.text = @"EVENTS";
    //
    //    self.followingLabel.textColor =  mainColor;
    //    self.followingLabel.font =  socialFont;
    //    self.followingLabel.text = @"ALERTS";
    //
    //    self.updateLabel.textColor =  mainColor;
    //    self.updateLabel.font =  socialFont;
    //    self.updateLabel.text = @"UPDATES";
    //
    
    //    self.bioLabel.textColor =  mainColor;
    //    self.bioLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    //    self.bioLabel.text = @"Suffering from Major Headache Symptoms";
    //
    //    self.friendLabel.textColor =  mainColor;
    //    self.friendLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];;
    //    self.friendLabel.text = @"My Doctors";
    //
    NSString *uPicture = @"http://www.centiva.co/newneuro/files/profile/";
    uPicture = [uPicture stringByAppendingString: responseDictionary[@"user_image"]];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: uPicture]];
    
    self.profileImageView.image = [UIImage imageWithData: imageData];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.profileImageView.layer.borderColor = imageBorderColor.CGColor;
    
    //    self.bioContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.bioContainer.layer.borderWidth = 4.0f;
    //    self.bioContainer.layer.cornerRadius = 5.0f;
    //
    //    self.friendContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.friendContainer.layer.borderWidth = 4.0f;
    //    self.friendContainer.clipsToBounds = YES;
    //    self.friendContainer.layer.cornerRadius = 5.0f;
    //
    //    [self styleFriendProfileImage:self.friendImageView1 withImageNamed:@"profile-1.jpg" andColor:imageBorderColor];
    //    [self styleFriendProfileImage:self.friendImageView2 withImageNamed:@"profile-2.jpg" andColor:imageBorderColor];
    //    [self styleFriendProfileImage:self.friendImageView3 withImageNamed:@"profile-3.jpg" andColor:imageBorderColor];
    
    // [self addDividerToView:self.scrollView atLocation:230];
    [self addDividerToView:self.scrollView atLocation:300];
    // [self addDividerToView:self.scrollView atLocation:370];
    
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

//-(NSData *) getUserData{
//   NSData * userData =  [[EHNetworkManager theManager] getUserDetails:2];
//    return userData;
//}

@end
