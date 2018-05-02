//
//  HTTPBinManagerOperation.h
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    httpBinManagerOperationFail = -1,
    httpBinManagerOperationSuccess = 1,
} HTTPBinManagerOperationStatus;

@class HTTPBinManagerOperation;

@protocol HTTPBinManagerOperationDelegate <NSObject>
-(void) httpBinManagerOperation: (HTTPBinManagerOperation*) operation status: (HTTPBinManagerOperationStatus) statusCode;
-(void) httpBinManagerOperation:(HTTPBinManagerOperation *) operation progress: (CGFloat) progressPercentage;
-(void) httpBinManagerOperation:(HTTPBinManagerOperation *)operation didGetObject: (NSArray <NSDictionary *> *) objects didGetImage: (UIImage *) image;
@end

@interface HTTPBinManagerOperation : NSOperation
@property (weak, nonatomic) id <HTTPBinManagerOperationDelegate> delegate;

@end
