//
//  EHSidebarCell.m
//  eHealth
//
//  Created by Nikhil Lele on 1/19/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EHSidebarCell.h"


@implementation EHSidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected){
        self.bgView.backgroundColor = self.mainColor;
    }
    else{
        self.bgView.backgroundColor = self.darkColor;
    }

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    self.mainColor = [UIColor clearColor];
    self.darkColor = [UIColor clearColor];
    
    self.bgView.backgroundColor = self.darkColor;
    
    self.topSeparator.backgroundColor = [UIColor clearColor];
    self.bottomSeparator.backgroundColor = [UIColor clearColor];
    
   // self.bottomSeparator.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.2f];
    
    NSString* boldFontName = @"Avenir-Black";
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.backgroundColor = self.mainColor;
    self.countLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    
    self.countLabel.layer.cornerRadius = 3.0f;
}


@end
