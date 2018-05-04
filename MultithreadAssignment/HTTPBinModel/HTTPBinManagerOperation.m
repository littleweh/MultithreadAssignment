//
//  HTTPBinManagerOperation.m
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "HTTPBinManagerOperation.h"
#import "ASWebServiceSDK.h"

@interface HTTPBinManagerOperation ()
@property (strong, nonatomic, readwrite) NSMutableArray <NSDictionary *> * jsonObjects;
@property (strong, nonatomic, readwrite) UIImage *image;
@end

@implementation HTTPBinManagerOperation

#pragma mark - lazy properties

-(NSMutableArray <NSDictionary *> *) jsonObjects {
    if (!_jsonObjects) {
        NSMutableArray * array = [NSMutableArray <NSDictionary *> array];
        _jsonObjects = array;
    }
    return _jsonObjects;
}

-(UIImage *) image {
    if (!_image) {
        UIImage * image = [[UIImage alloc] init];
        _image = image;
    }
    return _image;
}
-(void) setSdk:(ASWebServiceSDK *)sdk {
    _sdk = sdk;
}

#pragma mark - override main
-(void) main {
    @autoreleasepool {
        __weak HTTPBinManagerOperation *weakSelf = self;
        
        // fetchGetResponse
        [self.sdk fetchGetResponseWithCallback:^(NSDictionary *getRootObject, NSError *error) {
            [self quitRunloop];

            if (error) {
                [self cancel];
                if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{ 
                        [weakSelf.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail progress:0.0];
                        return;
                    });
                }
            }
            // success
            [self.jsonObjects addObject:getRootObject];
            if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate httpBinManagerOperation:self status:httpBinManagerOperationInProgress progress: 33.0];
                });
            }
        }];
        
        [self doRunloop];
        if (self.isCancelled) {
            return;
        }
        
        //postCustomerName
        [self.sdk postCustomerName:@"KKBOX" callback:^(NSDictionary *postCustNameObject, NSError *postError) {
            [self quitRunloop];

            if (postError) {
                [self cancel];
                if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail progress:33.0];
                        return;
                    });
                }
            }
            // success
            [self.jsonObjects addObject:postCustNameObject];
            if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate httpBinManagerOperation:self status:httpBinManagerOperationInProgress progress: 66.0];
                });
            }
        }];
        
        [self doRunloop];
        if (self.isCancelled) {
            return;
        }
        
        // fetchImage
        [self.sdk fetchImageWithCallback:^(UIImage *image, NSError *fetchImageError) {
            [self quitRunloop];
            if (fetchImageError) {
                [self cancel];
                if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail progress:66.0];
                        return;
                    });
                }
            }
            // success
            self.image = image;
            if ([self.delegate respondsToSelector:@selector(httpBinManagerOperation:didGetObject:didGetImage:)] && [self.delegate respondsToSelector:@selector(httpBinManagerOperation:status:progress:)] ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate httpBinManagerOperation:self status:httpBinManagerOperationSuccess progress:100.0];
                    [weakSelf.delegate httpBinManagerOperation:self didGetObject:(NSArray <NSDictionary *> *) self.jsonObjects didGetImage:self.image];
                });
            }
        }];
    }
}

-(void)doRunloop {
    runloopRunning = YES;
    port = [[NSPort alloc] init];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
    
    while (runloopRunning && !self.isCancelled) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
    }
    port = nil;
}

-(void)quitRunloop {
    [port invalidate];
    runloopRunning = NO;
}

-(void) cancel {
    [super cancel];
    [self quitRunloop];
}

@end
