//
//  SFSlideMenuViewController.m
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import "SFSlideMenuViewController.h"
#import "SFSlideMenuRootViewController.h"
#import "EHSidebarCell.h"

@interface SFSlideMenuViewController ()<SFSlideMenuDataSource,SFSlideMenuDelegate>
@property (nonatomic) NSIndexPath* currentContentIndexPath;
@end

@implementation SFSlideMenuViewController
#pragma mark -
#pragma mark Init
-(void)setup; {
    if(self.slideMenuDataSource == nil)
        self.slideMenuDataSource = self;
    if(self.slideMenuDelegate == nil)
        self.slideMenuDelegate = self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder; {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)init; {
    self = [super self];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)loadContentAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.slideMenuDataSource respondsToSelector:@selector(segueIdForIndexPath:)]) {
        UINavigationController* controller = [self.rootController controllerForIndexPath:indexPath];
        if (controller) {
            [self.rootController switchToContentViewController:controller completion:nil];
            return;
        }
        NSString* segueId = [self.slideMenuDataSource segueIdForIndexPath:indexPath];
        [self performSegueWithIdentifier:segueId sender:self];
        self.currentContentIndexPath = indexPath;
    }
}

#pragma mark -
#pragma mark SFSlideMenuViewController

-(void)selectContentAtIndexPath:(NSIndexPath *)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition{
    if ([self.slideMenuDataSource respondsToSelector:@selector(segueIdForIndexPath:)]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:scrollPosition];
     
        Boolean disableContentViewControllerCaching= NO;
        if ([self.slideMenuDataSource respondsToSelector:@selector(disableContentViewControllerCachingForIndexPath:)]) {
            disableContentViewControllerCaching = [self.slideMenuDataSource disableContentViewControllerCachingForIndexPath:indexPath];
        }

        [self loadContentAtIndexPath:indexPath];
    }
}

-(void) revealLeftMenu{
    [self.rootController doSlideToSide];
}
-(void) revealRightMenu{
    if (self.rootController.isRightMenuEnabled && self.rootController.rightMenu != nil) {
        [self.rootController addRightMenu];
        [self.rootController doSlideToLeftSide];
    }
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldRespondToGesture = YES;
    if ([self.slideMenuDataSource respondsToSelector:@selector(shouldRespondToGesture:forIndexPath:)]) {
        shouldRespondToGesture = [self.slideMenuDataSource shouldRespondToGesture:gestureRecognizer
                                                                     forIndexPath:self.currentContentIndexPath];
    }
    return shouldRespondToGesture;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}


#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadContentAtIndexPath:indexPath];
}


#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHSidebarCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell"];
    
    NSDictionary* item = self.items[indexPath.row];
    
    cell.titleLabel.text = item[@"title"];
    cell.iconImageView.image = [UIImage imageNamed:item[@"icon"]];
    
    NSString* count = item[@"count"];
    if(![count isEqualToString:@"0"]){
        cell.countLabel.text = count;
    }
    else{
        cell.countLabel.alpha = 0;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}



@end
