//
//  ASWebServiceSDK.m
//  WebServiceSDK
//
//  Created by Ada Kao on 25/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ASWebServiceSDK.h"

static NSString *const httpBinDomain = @"http://httpbin.org/";
static NSString *const endPointGet = @"get";
static NSString *const endPointPost = @"post";
static NSString *const endPointImagePNG = @"image/png";

@implementation ASWebServiceSDK

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
    NSString *getURLString = [[NSString alloc] initWithFormat: @"%@%@",httpBinDomain, endPointGet];
    NSURL *getURL = [NSURL URLWithString:getURLString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:getURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                // response check?
                                                // use method, enum, switch to handle status code; 500 -> return
                                                if ([response respondsToSelector:@selector(statusCode)]) {
                                                    if ([(NSHTTPURLResponse *) response statusCode] == 404) {
                                                        callback(nil, error);
                                                        return;
                                                    }
                                                }
                                                if (error != nil) {
                                                    callback(nil, error);
                                                    return;
                                                }

                                                NSError *parseJsonError = nil;
                                                NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
                                                
                                                if (parseJsonError) {
                                                    callback(nil, parseJsonError);
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    callback(jsonObject, nil);
                                                });

    }];
    [dataTask resume];
}

-(void)postCustomerName:(NSString *)name callback: (void(^)(NSDictionary *, NSError *)) callback {
    NSString *postURLString = [[NSString alloc] initWithFormat:@"%@%@", httpBinDomain, endPointPost];
    NSURL *postURL = [NSURL URLWithString:postURLString];

    NSString *post = [NSString stringWithFormat:@"custname=%@", name];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
                                                    // response check? how?
                                                    if ([response respondsToSelector:@selector(statusCode)]) {
                                                        if ([(NSHTTPURLResponse *) response statusCode] == 500) {
                                                            return;
                                                        } else if ([(NSHTTPURLResponse *) response statusCode] == 404) {
                                                            callback(nil, error);
                                                            return;
                                                        }
                                                    }
                                                    if (error != nil) {
                                                        callback(nil, error);
                                                        return;
                                                    }
                                                    NSError *parseJsonError = nil;
                                                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
                                                    
                                                    if (parseJsonError) {
                                                        callback(nil, parseJsonError);
                                                        return;
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        callback(jsonObject, nil);
                                                    });

    }];
    [dataTask resume];
}

-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback {
    NSString *fetchImageURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointImagePNG];
    NSURL *fetchImageURL = [NSURL URLWithString:fetchImageURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:fetchImageURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable
                                                                response, NSError * _Nullable error) {
                                                if (error) {
                                                    callback(nil, error);
                                                    return;
                                                }
                                                UIImage *image = [UIImage imageWithData:data];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    callback(image, nil);
                                                });
    }];
    [dataTask resume];
    
}

@end
