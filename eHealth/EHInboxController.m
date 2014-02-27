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
#import "JSMessage.h"

@interface EHInboxController ()
@property (nonatomic, strong) NSMutableArray *allMyMessagesArray;
@property (nonatomic, strong) NSString *imageUrl;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;

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
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:12.0f]];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.sender = @"admin";
    
    self.title = @"My Messages";
    self.messageInputView.textView.placeHolder = @"Send Message";
    [[EHNetworkManager theManager] addObserver:self forKeyPath:@"responseDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(void) viewWillAppear:(BOOL)animated{

    NSString * Account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];

    [[EHNetworkManager theManager] retrieveUserMessages:Account];
    [self scrollToBottomAnimated:NO];

}


#pragma local methods

-(void) renderAllMessages{
    
    //[self.messageInputView reloadInputViews];
    [self.tableView reloadData];
    
}

-(void) loadBubbleMessageData {
    
    self.messages = [NSMutableArray array];
    for (NSDictionary *messageData in self.allMyMessagesArray) {
        JSMessage *message = [[JSMessage alloc] initWithText:messageData[@"msg_desc"] sender:messageData[@"first_name"] date:messageData[@"msg_date"]];
        [self.messages addObject:message];
    }
}


#pragma JSMessagesViewDelegate delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allMyMessagesArray.count;
    
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    if ((self.messages.count - 1) % 2) {
        [JSMessageSoundEffect playMessageSentSound];
    }
    else {
        // for demo purposes only, mimicing received messages
        [JSMessageSoundEffect playMessageReceivedSound];
        sender = @"user";
        //TODO - replace this with current user name
    }
    
    [self.messages addObject:[[JSMessage alloc] initWithText:text sender:sender date:date]];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
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
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    NSString *userType = message[@"user_type"];
    if (userType && [userType isEqualToString:@"admin"])
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleBlueColor]];
    else
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
}

/*- (JSMessagesViewTimestampPolicy)timestampPolicy{
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy{
    return JSMessagesViewAvatarPolicyAll;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy{
    return JSMessagesViewSubtitlePolicyAll;
}
*/

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
        
        NSString *avatarImageUrl = [self.imageUrl stringByAppendingString:message[@"user_image"]];
        NSURL *url = [NSURL URLWithString:avatarImageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        return imageView;
    }
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    return message[@"first_name"];
}

#pragma mark - Messages view delegate: OPTIONAL

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    
    #if TARGET_IPHONE_SIMULATOR
        cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    #else
        cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    #endif

}

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard
{
    return YES;
}


#pragma mark - Messages view data source: REQUIRED

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    //return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile.jpg"]];
    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    if(!message[@"user_image"]){
        return nil;
    } else {
        
        NSString *avatarImageUrl = [self.imageUrl stringByAppendingString:message[@"user_image"]];
        NSURL *url = [NSURL URLWithString:avatarImageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        return imageView;
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
            [self loadBubbleMessageData];
            self.imageUrl = manager.responseDictionary[@"url"];
            [self renderAllMessages];
        } else {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:manager.responseDictionary[@"msg"]];
        }
    }
}

@end
