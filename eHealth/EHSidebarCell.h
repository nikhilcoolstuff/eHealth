//
//  EHSidebarCell.h
//  eHealth
//
//  Created by Nikhil Lele on 1/19/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHSidebarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* countLabel;

@property (nonatomic, weak) IBOutlet UIView* bgView;

@property (nonatomic, weak) IBOutlet UIView* topSeparator;

@property (nonatomic, weak) IBOutlet UIView* bottomSeparator;

@property (nonatomic, weak) IBOutlet UIImageView* iconImageView;

@property (nonatomic, strong) UIColor* mainColor;

@property (nonatomic, strong) UIColor* darkColor;

@end
