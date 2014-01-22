//
//  SFSlideMenuPushSegue.m
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import "SFSlideMenuPushSegue.h"
#import "SFSlideMenuRootViewController.h"
#import "SFSlideMenuRightMenuViewController.h"
#import "SFSlideMenuNavigationController.h"

@implementation SFSlideMenuPushSegue
-(void) perform{
    
    SFSlideMenuRightMenuViewController* source = self.sourceViewController;
    SFSlideMenuRootViewController* root = source.rootController;
    SFSlideMenuNavigationController* destination = self.destinationViewController;
    
    [root pushRightNavigationController:destination];
}

@end
