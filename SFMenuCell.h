//
//  SFSlideMenuCell.h
//  SFSlideMenu
//
//  Created by Nikhil Lele on 12/6/13.
//  Copyright (c) 2013 kyleBeyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMenuCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* itemDescription;
@property (nonatomic, weak) IBOutlet UIImageView* disclosureImage;

@end
