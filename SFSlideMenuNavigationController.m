//
//  SFSlideMenuNavigationController.m
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import "SFSlideMenuNavigationController.h"

@interface SFSlideMenuNavigationController ()

@end

@implementation SFSlideMenuNavigationController

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.topViewController == self.lastController) {
        [self.rootController popRightNavigationController];
        return nil;
    }else{
        return [super popViewControllerAnimated:animated];
    }
}

-(NSArray*) popToRootViewControllerAnimated:(BOOL)animated{
    NSArray* vcs = [super popToRootViewControllerAnimated:animated];
    [self.rootController popRightNavigationController];
    return vcs;
}
@end
