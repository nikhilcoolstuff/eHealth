//
//  SFSlideMenuDelegate.h
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.

#import <Foundation/Foundation.h>

@protocol SFSlideMenuDelegate <NSObject>

@optional

-(void)slideMenuWillSlideToSide:(UINavigationController*) selectedContent;
-(void)slideMenuDidSlideToSide:(UINavigationController*) selectedContent;

-(void)slideMenuWillSlideIn:(UINavigationController*) selectedContent;
-(void)slideMenuDidSlideIn:(UINavigationController*) selectedContent;

-(void)slideMenuWillSlideOut:(UINavigationController*) selectedContent;
-(void)slideMenuDidSlideOut:(UINavigationController*) selectedContent;

-(void) slideMenuWillSlideToLeft:(UINavigationController*) selectedContent;
-(void) slideMenuDidSlideToLeft:(UINavigationController*) selectedContent;

@end
