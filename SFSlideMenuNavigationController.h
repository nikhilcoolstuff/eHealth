//
//  SFSlideMenuNavigationController.h
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSlideMenuRootViewController.h"

@interface SFSlideMenuNavigationController : UINavigationController

@property (nonatomic,strong) SFSlideMenuRootViewController* rootController;
@property (nonatomic,strong) UIViewController* lastController;
@end
