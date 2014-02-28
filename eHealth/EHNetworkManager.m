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


-(void) makeServerRequestforServiceUrl:(NSString *)URL {
    
    // This is a local method to fetch all server data.  Users of the network manager class would eventually call this method to make a service request for the input URL.
    
    NSString *properlyEscapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // Create url connection and fire request
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!theConnection) {
        [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:@"Error connecting to the network. Please check your network connection and try again"];
        self.responseDictionary = nil;
    }
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil) {
        NSLog(@"Connection Successful");
    } else {
        [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:@"An error occured while fetching data."];
    }
}

-(void) sendLoginRequestWithId:(NSString *) login password:(NSString *) password {
    
    // Check User Login
    
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?func=getUserLogin&t=%@&e=%@&p=%@",kSecureToken,login, password];
    [self makeServerRequestforServiceUrl:URL];
}

-(void) retrieveUserMessages:(NSString *) userId {

    // Check User Messages
    //temp testing
    userId = @"15";
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=%@&func=getAllUserMessages&limit=0&id=%@",kSecureToken, userId];
    [self makeServerRequestforServiceUrl:URL];
}

-(void)getUserDetailsforUser:(NSString *)userId
{
    // retrieve user profile

    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?func=getUserData&t=&t=%@&id=%@",kSecureToken,userId];
    [self makeServerRequestforServiceUrl:URL];
}

-(void)getAllSymptoms
{
    // retrieve user headache symptoms.
    
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=centiva123&func=getAllSymptoms&d=1"];
    [self makeServerRequestforServiceUrl:URL];
}

-(void) getAllPains {
    
    // retrieve user pain levels.
    NSString *URL = [NSString stringWithFormat:@"http://centiva.co/newneuro/check.php?t=centiva123&func=getLevelOfPain"];
    [self makeServerRequestforServiceUrl:URL];
}


#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received. Every time we get an response it might be a forward, so we discard what data we have
    
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
   
    if (connection)
    {
        NSError* error;
        self.responseDictionary = [NSJSONSerialization
                                            JSONObjectWithData:self.responseData
                                            options:kNilOptions
                                            error:&error];
    }
    NSLog(@"did finish loading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // an error occured while making the request.
    [[EHAppDelegate theDelegate] showAlertWithTitle:@"Error" message:@"Error connecting to the server."];

}


@end
