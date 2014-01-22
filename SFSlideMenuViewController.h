//
//  SFSlideMenuViewController.h
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSlideMenuDataSource.h"
#import "SFSlideMenuDelegate.h"

@class SFSlideMenuRootViewController;

@interface SFSlideMenuViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) SFSlideMenuRootViewController* rootController;
@property (strong, nonatomic) NSObject<SFSlideMenuDataSource>* slideMenuDataSource;
@property (strong, nonatomic) NSObject<SFSlideMenuDelegate>* slideMenuDelegate;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* items;

-(void)selectContentAtIndexPath:(NSIndexPath *)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition;
-(void) revealLeftMenu;

-(void) revealRightMenu;

@end
