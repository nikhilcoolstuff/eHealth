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
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface EHInboxController ()
@property (nonatomic, strong) NSMutableArray *allMyMessagesArray;
@property (nonatomic, strong) NSString *imageUrl;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) UIImageView *defaultProfileImageView;
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
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    self.allMyMessagesArray = [[NSMutableArray alloc] init];
    self.navigationController.topViewController.title = @"My Messages";
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:12.0f]];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.sender = @"admin";
    
    self.title = @"My Messages";
    self.messageInputView.textView.placeHolder = @"New Message";
    [[EHNetworkManager theManager] addObserver:self forKeyPath:@"responseDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    self.defaultProfileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar-placeholder"]];
    self.messageInputView.textView.userInteractionEnabled = NO;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSString * Account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];

    [[EHNetworkManager theManager] retrieveUserMessages:Account];
    [self scrollToBottomAnimated:NO];

}


#pragma local methods

-(void) renderAllMessages{
    
    if (self.allMyMessagesArray.count) {
        self.messageInputView.textView.userInteractionEnabled = YES;
        [self.tableView reloadData];
    }
    
}

-(void) loadBubbleMessageData {
    
    self.messages = [NSMutableArray array];
    for (NSMutableDictionary *messageData in self.allMyMessagesArray) {
        NSString *dateString = messageData[@"msg_date"];
        NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *messageDate = [[NSDate alloc] init];
        messageDate = [dateFormattor dateFromString:dateString];
        JSMessage *message = [[JSMessage alloc] initWithText:messageData[@"msg_desc"] sender:messageData[@"first_name"] date:messageDate];
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
    [JSMessageSoundEffect playMessageSentSound];

    //add timestamp
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    JSMessage *message = [[JSMessage alloc] initWithText:text sender:sender date:now];
    [self.messages addObject:message];

    sender = @"user";
    //TODO - replace this with current user name

    NSMutableDictionary *newMessageDictionary = [NSMutableDictionary dictionary];
    [self.allMyMessagesArray addObject:newMessageDictionary];
    newMessageDictionary[@"first_name"] = sender;
    newMessageDictionary[@"msg_date"] = [dateFormatter stringFromDate:now];   //"2014-02-27 19:41:51";
    newMessageDictionary[@"msg_desc"] = text;
    newMessageDictionary[@"msg_id"] = @"TBD";
    NSString * Account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];
    newMessageDictionary[@"user_id_from"] = Account;
    newMessageDictionary[@"user_id_to"] = @"1";
    newMessageDictionary[@"user_image"] = @"bg-invite.gif";
    newMessageDictionary[@"user_type"] = @"user";
    [self loadBubbleMessageData];
    [self finishSend];
    [self scrollToBottomAnimated:YES];
    
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"Account"];
    [[EHNetworkManager theManager] pushMessagesToServer:text fromUserID:account];
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
    if([cell messageType] == JSBubbleMessageTypeIncoming) {
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

    NSMutableDictionary *message = self.allMyMessagesArray[indexPath.row];
    if(message[@"user_image"]){
        // asynchronously loading avatar images for user and admin.
        dispatch_async(kBgQueue, ^{

            NSString *avatarImageUrl = [self.imageUrl stringByAppendingString:message[@"user_image"]];
            NSURL *url = [NSURL URLWithString:avatarImageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        JSBubbleMessageCell *updateCell = (id)[self.tableView cellForRowAtIndexPath:indexPath];

                        if (updateCell)
                            [updateCell setAvatarImageView:cellImageView];
                    });
                }
            }
        });
    
    }
    return self.defaultProfileImageView;

}

#pragma network manager observer methods

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (![object isKindOfClass:[EHNetworkManager class]])
        return;
    
    EHNetworkManager *manager = object;
    if ([manager.responseDictionary[@"service"]  isEqualToString:@"getAllUserMessages"])
    {
        if ([manager.responseDictionary[@"status"] isEqualToString:@"yes"]) {
            
            NSArray *messageResponse = manager.responseDictionary[@"data"];
            self.allMyMessagesArray = [NSMutableArray arrayWithArray:messageResponse];
            [self loadBubbleMessageData];
            self.imageUrl = manager.responseDictionary[@"url"];
            [self renderAllMessages];
        } else {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:manager.responseDictionary[@"msg"]];
        }
    } else if ([manager.responseDictionary[@"service"]  isEqualToString:@"addMessage"]) {
        if (![manager.responseDictionary[@"status"] isEqualToString:@"yes"]) {
            [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:manager.responseDictionary[@"msg"]];
        }
    }

}

@end
