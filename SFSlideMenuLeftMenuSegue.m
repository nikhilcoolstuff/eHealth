//
//  SFSlideMenuLeftMenuSegue.m
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import "SFSlideMenuLeftMenuSegue.h"
#import "SFSlideMenuRootViewController.h"
#import "SFSlideMenuViewController.h"

@implementation SFSlideMenuLeftMenuSegue

-(void) perform{
    SFSlideMenuRootViewController* rootViewController = self.sourceViewController;
    SFSlideMenuViewController* leftMenu = self.destinationViewController;
    CGRect bounds = rootViewController.menuView.bounds;
    leftMenu.view.frame = CGRectMake(0,0,bounds.size.width,bounds.size.height);

    [leftMenu willMoveToParentViewController:rootViewController];
    [rootViewController addChildViewController:leftMenu];
    [rootViewController.menuView addSubview:leftMenu.view];
    rootViewController.leftMenu = leftMenu;
    
    leftMenu.rootController = rootViewController;
   
    [leftMenu didMoveToParentViewController:rootViewController];
    if ([rootViewController.leftMenu.slideMenuDataSource respondsToSelector:@selector(selectedIndexPath)]) {
        NSIndexPath* selectedIndexPath = [rootViewController.leftMenu.slideMenuDataSource selectedIndexPath];
        if (selectedIndexPath) {
            [leftMenu selectContentAtIndexPath:selectedIndexPath scrollPosition:UITableViewScrollPositionTop];
        }
    }   
}

@end
