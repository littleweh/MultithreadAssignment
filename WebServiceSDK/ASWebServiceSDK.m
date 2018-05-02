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


@interface ASWebServiceSDK ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray <NSURLSessionDataTask *> * dataTasks;
@end

@implementation ASWebServiceSDK


#pragma mark - singleton
+(instancetype) sharedInstance {
    static ASWebServiceSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASWebServiceSDK alloc]init];
    });
    return instance;
}

#pragma mark - lazy property

-(NSURLSession *) session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 60;
        configuration.timeoutIntervalForResource = 60;
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

-(NSMutableArray <NSURLSessionDataTask *> *) dataTasks {
    if (!_dataTasks) {
        NSMutableArray *array = [NSMutableArray<NSURLSessionDataTask *> array];
        _dataTasks = array;
    }
    return _dataTasks;
}

#pragma mark - GET, POST methods

-(void)fetchGetResponseWithCallback: (void(^)(NSDictionary *, NSError *)) callback {
    NSString *getURLString = [[NSString alloc] initWithFormat: @"%@%@",httpBinDomain, endPointGet];
    NSURL *getURL = [NSURL URLWithString:getURLString];
    
    NSURLSession *session = self.session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:getURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {

                                                if ([response respondsToSelector:@selector(statusCode)]) {
                                                    NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];

                                                    switch (statusCode) {
                                                        case 500:
                                                            callback(nil, error);
                                                            return;
                                                        case 400 ... 499:
                                                        case 300 ... 399:
                                                            callback(nil, error);
                                                            return;
                                                        case 200 ... 299:
                                                            break;
                                                        default:
                                                            break;
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
    dataTask.taskDescription = [NSString stringWithFormat:@"get response"];
    [self.dataTasks addObject:dataTask];
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
    
    NSURLSession *session = self.session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
                                                    if ([response respondsToSelector:@selector(statusCode)]) {
                                                        NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
                                                        
                                                        switch (statusCode) {
                                                            case 500:
                                                                callback(nil, error);
                                                                return;
                                                            case 400 ... 499:
                                                            case 300 ... 399:
                                                                callback(nil, error);
                                                                return;
                                                            case 200 ... 299:
                                                                break;
                                                            default:
                                                                break;
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
    dataTask.taskDescription = [NSString stringWithFormat:@"post customer name"];
    [self.dataTasks addObject:dataTask];
    [dataTask resume];
}

-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback {
    NSString *fetchImageURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointImagePNG];
    NSURL *fetchImageURL = [NSURL URLWithString:fetchImageURLString];
    
    NSURLSession *session = self.session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:fetchImageURL
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable
                                                                response, NSError * _Nullable error) {
                                                if ([response respondsToSelector:@selector(statusCode)]) {
                                                    NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
                                                    
                                                    switch (statusCode) {
                                                        case 500:
                                                            callback(nil, error);
                                                            return;
                                                        case 400 ... 499:
                                                        case 300 ... 399:
                                                            callback(nil, error);
                                                            return;
                                                        case 200 ... 299:
                                                            break;
                                                        default:
                                                            break;
                                                    }
                                                }

                                                if (error) {
                                                    callback(nil, error);
                                                    return;
                                                }
                                                UIImage *image = [UIImage imageWithData:data];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    callback(image, nil);
                                                });
    }];
    dataTask.taskDescription = [NSString stringWithFormat:@"get image"];
    [self.dataTasks addObject:dataTask];
    [dataTask resume];
    
}

@end
