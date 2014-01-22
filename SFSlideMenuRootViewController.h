//
//  SFSlideMenuRootViewController.h
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSlideMenuViewController.h"

@class SFSlideMenuNavigationController;
@class SFSlideMenuViewController;
@interface SFSlideMenuRootViewController : UIViewController


@property (nonatomic,strong) SFSlideMenuViewController* leftMenu;
@property (nonatomic,strong) UIViewController* rightMenu;
@property (nonatomic,assign) Boolean isRightMenuEnabled;
@property (nonatomic,strong) SFSlideMenuNavigationController* navigationController;

@property (nonatomic,strong) IBOutlet UIView* menuView;

-(void) switchToContentViewController:(UINavigationController*) content completion:(void (^)(void))completion;
-(void) addContentViewController:(UIViewController*) content withIndexPath:(NSIndexPath*)indexPath;

-(void) popRightNavigationController;
-(void) pushRightNavigationController:(SFSlideMenuNavigationController*)navigationController;

-(UINavigationController*) controllerForIndexPath:(NSIndexPath*) indexPath;

-(void) doSlideToSide;
-(void) doSlideToLeftSide;
-(void) rightMenuAction;
-(void) addRightMenu;

-(void) panItem:(UIPanGestureRecognizer*)gesture;
@end
