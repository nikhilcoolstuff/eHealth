//
//  EHCreateEventController.h
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHCreateEventController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *screenScrollView;
@property (weak, nonatomic) IBOutlet UITableView *symptomsTableView;
@property (weak, nonatomic) IBOutlet UITextView *eventDescTextView;
@property (weak, nonatomic) IBOutlet UITextView *painLevelTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *levelsPickerView;
@property (weak, nonatomic) IBOutlet UITextView *extraDetailsTextView;
@end
