//
//  HTTPBinManager.m
//  MultithreadAssignment
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "HTTPBinManager.h"

@implementation HTTPBinManager

+(instancetype) sharedInstance {
    static HTTPBinManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HTTPBinManager alloc]init];
    });
    return instance;
}

@end
