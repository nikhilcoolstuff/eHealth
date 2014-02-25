//
//  EHInboxController.m
//  eHealth
//
//  Created by Nikhil Lele on 1/22/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHInboxController.h"
#import "EHNetworkManager.h"
#import "EHAppDelegate.h"

@interface EHInboxController ()
@property (nonatomic, strong) NSMutableArray *allMyMessagesArray;
@end

@implementation EHInboxController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allMyMessagesArray = [NSMutableArray new];
    self.navigationController.topViewController.title = @"My Messages";
    self.delegate = self;
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"My Messages";
    self.messageInputView.textView.placeHolder = @"Send Message";
    [[EHNetworkManager theManager] addObserver:self forKeyPath:@"responseDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(void) viewWillAppear:(BOOL)animated{

    NSString * Account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];

    [[EHNetworkManager theManager] retrieveUserMessages:Account];

}


#pragma local methods

-(void) renderAllMessages{
    
    //[self.messageInputView reloadInputViews];
    [self.tableView reloadData];
    
}


#pragma JSMessagesViewDelegate delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allMyMessagesArray.count;
    
}

- (void)didSendText:(NSString *)text{
    [self.messageInputView reloadInputViews];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    NSString *userType = message[@"user_type"];
    if (userType && [userType isEqualToString:@"admin"])
        return JSBubbleMessageTypeIncoming;
    else
        return JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath{
  //  return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile.jpg"]];
  //  NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
  //  NSString *userType = message[@"user_type"];
  //  if (userType && [userType isEqualToString:@"admin"])
  //      return JSBubbleMessageTypeIncoming;
  //  else
  //      return JSBubbleMessageTypeOutgoing;

    return Nil;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy{
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy{
    return JSMessagesViewAvatarPolicyAll;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy{
    return JSMessagesViewSubtitlePolicyAll;
}

- (JSMessageInputViewStyle)inputViewStyle{
    return JSMessageInputViewStyleFlat;
}

#pragma JSMessagesViewDataSource delegate methods

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    return message[@"msg_desc"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    return message[@"msg_date"];
    
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile.jpg"]];
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    if(!message[@"user_image"]){
        return nil;
    } else {
        //UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:message[@"user_image"]];
        //return avatarImageView;
        //TODO
        return nil;
    }
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"subtitle";
}

- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:UITextAttributeTextColor];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    
    if(cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if(cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma network manager observer methods 

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (![object isKindOfClass:[EHNetworkManager class]])
        return;
    
    EHNetworkManager *manager = object;
    if ([manager.responseDictionary[@"service"]  isEqualToString:@"getAllUserMessages"])
    {
        if ([manager.responseDictionary[@"status"] isEqualToString:@"yes"]) {
            self.allMyMessagesArray = manager.responseDictionary[@"data"];
            [self renderAllMessages];
        } else {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:manager.responseDictionary[@"msg"]];
        }
    }
}

@end
