//
//  ASWebServiceSDK.h
//  WebServiceSDK
//
//  Created by Ada Kao on 25/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASWebServiceSDK : NSObject
-(void)fetchGetResponseWithCallback: (void(^)(NSDictionary *, NSError *)) callback;
-(void)postCustomerNamer:(NSString *)name callback: (void(^)(NSDictionary *, NSError *)) callback;
-(void)fetchImageWithCallback: (void(^)(UIImage *, NSError *)) callback;

@end
