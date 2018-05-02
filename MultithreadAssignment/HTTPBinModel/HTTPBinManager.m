//
//  HTTPBinManager.m
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "HTTPBinManager.h"

@interface HTTPBinManager ()
@property (strong, nonatomic, readwrite) NSOperationQueue * operationQueue;
@end

@implementation HTTPBinManager

#pragma mark - lazy property
-(NSOperationQueue *) operationQueue {
    if (!_operationQueue) {
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        _operationQueue = queue;
    }
    return _operationQueue;
}

#pragma mark - singleton
+(instancetype) sharedInstance {
    static HTTPBinManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HTTPBinManager alloc]init];
    });
    return instance;
}

-(void) executeOperation: (HTTPBinManagerOperation *) operation {
    [operation setDelegate:self];
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperation:operation];
}


#pragma mark: HTTPBinManagerOperationDelegate
- (void)httpBinManagerOperation:(HTTPBinManagerOperation *)operation didGetObject:(NSArray<NSDictionary *> *)objects didGetImage:(UIImage *)image {
    NSLog(@"in HTTPBinManager, jsonObjects: %@", objects);
    if ([self.delegate respondsToSelector:@selector(httpBinManager:didGetObject:didGetImage:)]) {
        [self.delegate httpBinManager:self didGetObject:objects didGetImage:image];
    }
}

- (void)httpBinManagerOperation:(HTTPBinManagerOperation *)operation progress:(CGFloat)progressPercentage {
    NSLog(@"in HTTPBinManager, progressPercentage: %f", progressPercentage);
    if ([self.delegate respondsToSelector:@selector(httpBinManager:progress:)]) {
        [self.delegate httpBinManager:self progress:progressPercentage];
    }
}

- (void)httpBinManagerOperation:(HTTPBinManagerOperation *)operation status:(HTTPBinManagerOperationStatus)statusCode {
    NSLog(@"in HTTPBinManager, status code: %ld", (unsigned long)statusCode);
    if ([self.delegate respondsToSelector:@selector(httpBinManager:status:)]) {
        [self.delegate httpBinManager:self status:statusCode];
    }
}

@synthesize delegate;

@end