//
//  EHNetworkManager.m
//  eHealth
//
//  Created by Nikhil Lele on 1/17/14.
//  Copyright (c) 2014 eHealth. All rights reserved.
//

#import "EHNetworkManager.h"
#import "EHAppDelegate.h"
#define kSecureToken @"centiva123"
#define kDefaultTimeout 120.0f // in seconds
#define kMaxOperationNumber 10

@interface EHNetworkManager()

@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, assign) float defaultTimeout;
@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong, readwrite) NSMutableDictionary *responseDictionary;
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation EHNetworkManager

+ (EHNetworkManager *)theManager
{
    // Shared Instance
    static EHNetworkManager* sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EHNetworkManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = kMaxOperationNumber;
        _defaultTimeout = kDefaultTimeout;
    }
    return self;
}

-(void) sendLoginRequestWithId:(NSString *) login password:(NSString *) password {
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?func=getUserLogin&t=%@&e=%@&p=%@",kSecureToken,login, password];
    [self makeServerRequestforServiceUrl:URL];
}

-(void) retrieveUserMessages:(NSString *) userId {
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=%@&func=getAllUserMessages&limit=0&id=%@",kSecureToken, userId];
    [self makeServerRequestforServiceUrl:URL];
}

-(void) makeServerRequestforServiceUrl:(NSString *)URL {
 
    NSString *properlyEscapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    // request.timeoutInterval = kDefaultTimeout;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    //  NSLog(@"Data is :=@" , response);
    if (error == nil) {
        NSLog(@"Connection Successful");
    } else {
        [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:@"Unable to connect"];
    }
    
}

-(void)getUserDetails:(NSString *) uid
{
    
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?func=getUserData&t=&t=%@&id=%@",kSecureToken,uid];
    [self makeServerRequestforServiceUrl:URL];

}

-(NSData *)getAllSymptoms
{
    
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=centiva123&func=getAllSymptoms&d=1"];
    
    NSString *properlyEscapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    // request.timeoutInterval = kDefaultTimeout;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    return data;
}

-(NSData *) getAllPains {
    
    
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=centiva123&func=getLevelOfPain"];
    
    NSString *properlyEscapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    // request.timeoutInterval = kDefaultTimeout;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    return data;
}


#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received
    
	// every time we get an response it might be a forward, so we discard what data we have
    
    self.responseData = [[NSMutableData alloc] init];
    NSLog(@"did receive response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
    NSLog(@"did receive data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"did finish loading");
    if (connection)
    {
        NSError* error;
        self.responseDictionary = [NSJSONSerialization
                                            JSONObjectWithData:self.responseData
                                            options:kNilOptions
                                            error:&error];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}


#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
}


@end
