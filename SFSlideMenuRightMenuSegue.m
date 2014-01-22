//
//  SFSlideMenuRightMenuSegue.m
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.

#import "SFSlideMenuRightMenuSegue.h"
#import "SFSlideMenuRootViewController.h"
#import "SFSlideMenuRightMenuViewController.h"
@implementation SFSlideMenuRightMenuSegue
-(void) perform{
    UINavigationController* source = self.sourceViewController;
    
    SFSlideMenuRightMenuViewController* rightMenuViewController = self.destinationViewController;
    SFSlideMenuRootViewController* rootViewController = (SFSlideMenuRootViewController*)source.parentViewController;
    
    rootViewController.rightMenu = rightMenuViewController;
    rightMenuViewController.rootController = rootViewController;
}

@end
