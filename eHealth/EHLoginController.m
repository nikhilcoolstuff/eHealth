//
//  EHLoginController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/18/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHLoginController.h"
#import "MBFlatAlertView.h"
#import "MBHUDView.h"
#define kLoginSuccess @"loginSuccessfulNotification"

@interface EHLoginController ()

@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton * forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;

@end

@implementation EHLoginController

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
    
    //    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* mainColor = [UIColor colorWithRed:51.0/255 green:204.0/255 blue:255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    // self.view.backgroundColor = mainColor;
    self.view.backgroundColor =[UIColor whiteColor];
    self.usernameField.delegate = self;
    self.usernameField.tag = 0;
    self.usernameField.backgroundColor = [UIColor whiteColor];
    
    self.usernameField.layer.cornerRadius = 3.0f;
    self.usernameField.placeholder = @"Email Address";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.returnKeyType = UIReturnKeyNext;
    
    UIImageView* usernameIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    usernameIconImage.image = [UIImage imageNamed:@"mail"];
    UIView* usernameIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    usernameIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [usernameIconContainer addSubview:usernameIconImage];
    
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = usernameIconContainer;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    self.passwordField.delegate = self;
    self.passwordField.tag = 1;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    
    
    UIImageView* passwordIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    passwordIconImage.image = [UIImage imageNamed:@"lock"];
    UIView* passwordIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    passwordIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [passwordIconContainer addSubview:passwordIconImage];
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = passwordIconContainer;
    
    //  self.loginButton.backgroundColor = darkColor;
    self.loginButton.backgroundColor = mainColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    //   self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.signupButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.signupButton setTitle:@"Sign Up ?" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    // self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.textColor=mainColor;
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"GOOD TO SEE YOU";
    
    //   self.subTitleLabel.textColor =  [UIColor whiteColor];
    self.subTitleLabel.textColor=mainColor;
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Welcome back, please login below";
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userIsValid:)
                                                 name:kLoginSuccess
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma actions

- (IBAction)loginAction:(id)sender {
    // [self pains];
    
    // [self symptoms];
    [self loginProcess];
    
}

- (IBAction)forgotAction:(id)sender {
    [self forgotPasswordProcess];
}

#pragma validate email

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma textField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self loginProcess];
    }
    return NO;
}

#pragma local Methods

-(void) loginProcess {
    
    if (self.usernameField.text.length && self.passwordField.text.length) {
        
        BOOL VALID = [self NSStringIsValidEmail:self.usernameField.text];
        
        if (VALID){
            [MBHUDView hudWithBody:@"Logging in..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:4.0 show:YES];
            [[EHNetworkManager theManager] sendLoginRequestWithId:self.usernameField.text password:self.passwordField.text];
            
        } else
            [self showAlertWithTitle:@"Error" message:@"Please enter a valid email address"];
    } else {
        
        [self showAlertWithTitle:@"Error" message:@"User name or password cannot be blank"];
    }
}

-(void) forgotPasswordProcess {
    //TODO: logic to forgot password
}

-(void) symptoms
{
    [[EHNetworkManager theManager] getAllSymptoms];
}
-(void) pains
{
    [[EHNetworkManager theManager] getAllPains];
}


-(void) showAlertWithTitle:(NSString *)title message:(NSString *) message {
    
    MBFlatAlertView *alert = [MBFlatAlertView alertWithTitle:title detailText:message cancelTitle:@"OK" cancelBlock:^{
        [self.usernameField becomeFirstResponder];
    }];
    
    [alert addToDisplayQueue];
    
}


#pragma network manager delegate

-(void) userIsValid:(NSNotification *) notification {
    
    NSLog(@"Notification from userIdValid : %@",notification);
    // login authenticated
    if (!notification) {
        return;
    }
    NSLog(@"login has been authenticated");
    //SFSlideMenuRootViewController
    
    //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    //  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"slideMenuRootVC"];
    //  [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
}

@end
