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
    return [NSString stringWithFormat:@"http://httpbin.org/"];
}
-(NSString*) endPointGet {
    return [NSString stringWithFormat:@"get"];
}

-(NSString*) endPointPost {
    return [NSString stringWithFormat:@"post"];
}

-(NSString*) endPointImagePNG {
    return [NSString stringWithFormat:@"image/png"];
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
                                                // response check?
                                                if ([response respondsToSelector:@selector(statusCode)]) {
                                                    if ([(NSHTTPURLResponse *) response statusCode] == 404) {
                                                        callback(nil, error);
                                                    }
                                                }
                                                if (error != nil) {
                                                    callback(nil, error);
                                                }

                                                NSError *parseJsonError = nil;
                                                NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
                                                NSLog(@"%@", jsonObject);
                                                if (!parseJsonError) {
                                                    callback(jsonObject, nil);
                                                } else {
                                                    callback(nil, parseJsonError);
                                                }
    }];
    [dataTask resume];
}

-(void)postCustomerName:(NSString *)name callback: (void(^)(NSDictionary *, NSError *)) callback {
    NSString *postURLString = [[NSString alloc] initWithFormat:@"%@%@?custname=%@", self.httpbinDomain, self.endPointPost, name];
    NSURL *postURL = [NSURL URLWithString:postURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
                                                    // response check? how?
                                                    if ([response respondsToSelector:@selector(statusCode)]) {
                                                        if ([(NSHTTPURLResponse *) response statusCode] == 404) {
                                                            callback(nil, error);
                                                        }
                                                    }
                                                    if (error != nil) {
                                                        callback(nil, error);
                                                    }
                                                    NSLog(@"%@", response);
                                                    NSError *parseJsonError = nil;
                                                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
                                                    if (!parseJsonError) {
                                                        callback(jsonObject, nil);
                                                    } else {
                                                        callback(nil, parseJsonError);
                                                    }
    }];
    [dataTask resume];
}

-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback {
    NSString *fetchImageURLString = [NSString stringWithFormat:@"%@%@", self.httpbinDomain, self.endPointImagePNG];
    NSURL *fetchImageURL = [NSURL URLWithString:fetchImageURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:fetchImageURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable
                                                                response, NSError * _Nullable error) {
                                                if (error != nil) {
                                                    callback(nil, error);
                                                }
                                                UIImage *image = [UIImage imageWithData:data];
                                                callback(image, nil);
    }];
    [dataTask resume];
    
}

@end
