//
//  HTTPBinManager.h
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPBinManagerOperation.h"
@class HTTPBinManager;
@protocol HTTPBinManagerDelegate <NSObject>
-(void) httpBinManager: (HTTPBinManager *) manager status: (HTTPBinManagerOperationStatus) statusCode progress: (CGFloat) progressPercentage;
-(void) httpBinManager:(HTTPBinManager *) manager didGetObject: (NSArray <NSDictionary *> *) objects didGetImage: (UIImage *) image;
@end


@interface HTTPBinManager : NSObject <HTTPBinManagerOperationDelegate>
@property (strong, nonatomic, readonly) NSOperationQueue * operationQueue;
@property (weak, nonatomic) id <HTTPBinManagerDelegate> delegate;
+(instancetype) sharedInstance;
-(void) executeOperation: (HTTPBinManagerOperation *) operation;

@end
