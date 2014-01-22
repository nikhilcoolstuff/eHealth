//
//  EHProfileController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHProfileController.h"

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
	// Do any additional setup after loading the view.
    self.navigationController.topViewController.title = @"Profile";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
