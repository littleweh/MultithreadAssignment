//
//  ASWebServiceSDK.m
//  WebServiceSDK
//
//  Created by Ada Kao on 25/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ASWebServiceSDK.h"

@interface ASWebServiceSDK ()
@property (strong, nonatomic, readwrite) NSString *httpbinDomain;
@property (strong, nonatomic, readwrite) NSString *endPointGet;
@property (strong, nonatomic, readwrite) NSString *endPointPost;
@property (strong, nonatomic, readwrite) NSString *endPointImagePNG;

@end

@implementation ASWebServiceSDK
-(NSString*) httpbinDomain {
    return @"http://httpbin.org/";
}
-(NSString*) endPointGet {
    return @"get";
}

-(NSString*) endPointPost {
    return @"post";
}

-(NSString*) endPointImagePNG {
    return @"image/png";
}

+(instancetype) sharedInstance {
    static ASWebServiceSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASWebServiceSDK alloc]init];
    });
    return instance;
}

-(void)fetchGetResponseWithCallback: (void(^)(NSDictionary *, NSError *)) callback {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *getURLString = [[NSString alloc] initWithFormat: @"%@%@",self.httpbinDomain, self.endPointGet];
    NSURL *getURL = [NSURL URLWithString:getURLString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:getURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    callback(nil, error);
                                                }
                                                NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                NSLog(@"%@", jsonObject);
                                                callback(jsonObject, nil);
    }];
    [dataTask resume];
    
}
-(void)postCustomerNamer:(NSString *)name callback: (void(^)(NSDictionary *, NSError *)) callback {
    NSString *postURLString = [[NSString alloc] initWithFormat:@"%@%@?custname=%@", self.httpbinDomain, self.endPointPost, name];
    NSURL *postURL = [NSURL URLWithString:postURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    // set headers??
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            callback(nil, error);
        }
        NSLog(@"%@", response);
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        callback(jsonObject, nil);
        
    }];
    [dataTask resume];
}
-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback {
    
}

@end
