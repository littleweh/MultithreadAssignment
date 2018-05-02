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

#pragma mark - override main
-(void) main {
    @autoreleasepool {
        // call API
        ASWebServiceSDK * sdk = [ASWebServiceSDK sharedInstance];
        [sdk fetchGetResponseWithCallback:^(NSDictionary *getRootObject, NSError *error) {
            if (error) {
                // ToDo: cancel the whole operation
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail];
                    return;
                });
            }
            // success
            [self.jsonObjects addObject:getRootObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate httpBinManagerOperation:self progress: 33.0];
            });
            
            [sdk postCustomerName:@"KKBOX" callback:^(NSDictionary *postCustNameObject, NSError *postError) {
                if (postError) {
                    // ToDo: cancel the whole operation
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail];
                        return;
                    });
                }
                // success
                [self.jsonObjects addObject:postCustNameObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate httpBinManagerOperation:self progress: 66.0];
                });
                
                [sdk fetchImageWithCallback:^(UIImage *image, NSError *fetchImageError) {
                    if (fetchImageError) {
                        // ToDo: cancel the whole operation
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate httpBinManagerOperation:self status: httpBinManagerOperationFail];
                            return;
                        });
                    }
                    // success
                    self.image = image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate httpBinManagerOperation:self progress: 100.0];
                        [self.delegate httpBinManagerOperation:self didGetObject:self.jsonObjects didGetImage:self.image];
                    });
                    
                }];
            }];
        }];
    }
}

@end
