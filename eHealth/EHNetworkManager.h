//
//  EHNetworkManager.h
//  eHealth
//
//  Created by Nikhil Lele on 1/17/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EHNetworkManagerDelegate;

@interface EHNetworkManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, weak) id <EHNetworkManagerDelegate> delegate;

-(void) sendRequest;
+ (EHNetworkManager *)theManager;

@end

@protocol EHNetworkManagerDelegate <NSObject>
@optional
-(void) userIsValid;

@end