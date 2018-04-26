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
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:getURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
    
}
-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback {
    
}

@end
