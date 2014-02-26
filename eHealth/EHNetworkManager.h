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

@property (nonatomic, strong, readonly) NSMutableDictionary *responseDictionary;

-(void) sendLoginRequestWithId:(NSString *) login password:(NSString *) password;
-(void)getUserDetailsforUser:(NSString *)userId;
-(void)getAllSymptoms;
-(void) getAllPains;
-(void) retrieveUserMessages:(NSString *) userId;

+ (EHNetworkManager *)theManager;

@end