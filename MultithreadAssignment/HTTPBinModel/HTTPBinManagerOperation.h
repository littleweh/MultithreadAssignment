//
//  HTTPBinManagerOperation.h
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "ASWebServiceSDK.h"

typedef enum : NSUInteger {
    httpBinManagerOperationBegin = 0,
    httpBinManagerOperationInProgress = 1,
    httpBinManagerOperationSuccess = 2,
    httpBinManagerOperationFail = 3
} HTTPBinManagerOperationStatus;

@class HTTPBinManagerOperation;

@protocol HTTPBinManagerOperationDelegate <NSObject>
-(void) httpBinManagerOperation: (HTTPBinManagerOperation*) operation status: (HTTPBinManagerOperationStatus) statusCode progress: (CGFloat) progressPercentage;
-(void) httpBinManagerOperation:(HTTPBinManagerOperation *)operation didGetObject: (NSArray <NSDictionary *> *) objects didGetImage: (UIImage *) image;
@end

@interface HTTPBinManagerOperation : NSOperation
{
    NSPort *port;
    BOOL runloopRunning;
}
@property (weak, nonatomic) id <HTTPBinManagerOperationDelegate> delegate;
@property (strong, nonatomic) ASWebServiceSDK * sdk;

@end
