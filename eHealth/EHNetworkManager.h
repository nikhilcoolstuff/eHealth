//
//  EHNetworkManager.h
//  eHealth
//
//  Created by Nikhil Lele on 1/17/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHNetworkManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;

-(void) sendRequest;
+ (EHNetworkManager *)theManager;

@end
