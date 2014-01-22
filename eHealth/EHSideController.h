//
//  EHSideController.h
//  eHealth
//
//  Created by Nikhil Lele on 1/19/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSlideMenuViewController.h"
#import "SFSlideMenuDataSource.h"

@interface EHSideController : SFSlideMenuViewController <SFSlideMenuDataSource,SFSlideMenuDelegate>
@end
