//
//  WebServiceSDKTests.m
//  WebServiceSDKTests
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASWebServiceSDK.h"

@interface WebServiceSDKTests : XCTestCase

@end

@implementation WebServiceSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testFetchGetResponseWithCallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGet"];
    
    [[ASWebServiceSDK sharedInstance] fetchGetResponseWithCallback:^(NSDictionary *rootObject, NSError *error) {
        XCTAssert([rootObject objectForKey:@"args"] != nil, @"there's no object with key \"args\" existed");
        XCTAssert([rootObject objectForKey:@"headers"] != nil, @"there's no object with key \"headers\" existed");
        XCTAssert([rootObject objectForKey:@"origin"] != nil, @"there's no object with key \"origin\" existed");
        XCTAssert([rootObject objectForKey:@"url"] != nil, @"there's no object with key \"url\" existed");
        
        XCTAssert([[rootObject objectForKey:@"args"] isKindOfClass:[NSDictionary class]], @"args class: %@", NSStringFromClass([[rootObject objectForKey:@"args"] class]));
        XCTAssert([[rootObject objectForKey:@"headers"] isKindOfClass:[NSDictionary class]], @"headers class: %@", NSStringFromClass([[rootObject objectForKey:@"headers"] class]));
        XCTAssert([[rootObject objectForKey:@"origin"] isKindOfClass:[NSString class]], @"origin class: %@", NSStringFromClass([[rootObject objectForKey:@"origin"] class]));
        XCTAssert([[rootObject objectForKey:@"url"] isKindOfClass:[NSString class]], @"url class: %@", NSStringFromClass([[rootObject objectForKey:@"url"] class]));
        
        NSDictionary *headersObject = [rootObject objectForKey:@"headers"];

        XCTAssert([headersObject objectForKey:@"Accept"] != nil, @"there's no object with key \"Accept\" existed");
        XCTAssert([headersObject objectForKey:@"Accept-Encoding"] != nil, @"there's no object with key \"Accept-Encoding\" existed");
        XCTAssert([headersObject objectForKey:@"Accept-Language"] != nil, @"there's no object with key \"Accept-Language\" existed");
        XCTAssert([headersObject objectForKey:@"Connection"] != nil, @"there's no object with key \"Connection\" existed");
        XCTAssert([headersObject objectForKey:@"Host"] != nil, @"there's no object with key \"Host\" existed");
        XCTAssert([headersObject objectForKey:@"User-Agent"] != nil, @"there's no object with key \"User-Agent\" existed");
        
        XCTAssert([[headersObject objectForKey:@"Accept"] isKindOfClass:[NSString class]], @"Accept class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept"] class]));
        XCTAssert([[headersObject objectForKey:@"Accept-Encoding"] isKindOfClass:[NSString class]], @"Accept-Encoding class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept-Encoding"] class]));
        XCTAssert([[headersObject objectForKey:@"Accept-Language"] isKindOfClass:[NSString class]], @"Accept-Language class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept-Language"] class]));
        XCTAssert([[headersObject objectForKey:@"Connection"] isKindOfClass:[NSString class]], @"Connection class: %@", NSStringFromClass([[headersObject objectForKey:@"Connection"] class]));
        XCTAssert([[headersObject objectForKey:@"Host"] isKindOfClass:[NSString class]], @"Host class: %@", NSStringFromClass([[headersObject objectForKey:@"Host"] class]));
        XCTAssert([[headersObject objectForKey:@"User-Agent"] isKindOfClass:[NSString class]], @"User-Agent class: %@", NSStringFromClass([[headersObject objectForKey:@"User-Agent"] class]));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

-(void) testPostCustomerName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testPostCustomerName"];
    NSString *inputName = [NSString stringWithFormat:@"Avengers"];
    [[ASWebServiceSDK sharedInstance] postCustomerName:inputName callback:^(NSDictionary *rootObject, NSError *error) {
        XCTAssert([rootObject objectForKey:@"args"] != nil, @"there's no object with key \"args\" existed");
        XCTAssert([rootObject objectForKey:@"data"] != nil, @"there's no object with key \"data\" existed");
        XCTAssert([rootObject objectForKey:@"files"] != nil, @"there's no object with key \"files\" existed");
        XCTAssert([rootObject objectForKey:@"form"] != nil, @"there's no object with key \"form\" existed");
        XCTAssert([rootObject objectForKey:@"headers"] != nil, @"there's no object with key \"headers\" existed");
        XCTAssert([rootObject objectForKey:@"json"] != nil, @"there's no object with key \"json\" existed");
        XCTAssert([rootObject objectForKey:@"origin"] != nil, @"there's no object with key \"origin\" existed");
        XCTAssert([rootObject objectForKey:@"url"] != nil, @"there's no object with key \"url\" existed");
        
        XCTAssert([[rootObject objectForKey:@"args"] isKindOfClass:[NSDictionary class]], @"args class: %@", NSStringFromClass([[rootObject objectForKey:@"args"] class]));
        XCTAssert([[rootObject objectForKey:@"data"] isKindOfClass:[NSString class]], @"data class: %@", NSStringFromClass([[rootObject objectForKey:@"data"] class]));
        XCTAssert([[rootObject objectForKey:@"files"] isKindOfClass:[NSDictionary class]], @"files class: %@", NSStringFromClass([[rootObject objectForKey:@"files"] class]));
        XCTAssert([[rootObject objectForKey:@"form"] isKindOfClass:[NSDictionary class]], @"form class: %@", NSStringFromClass([[rootObject objectForKey:@"form"] class]));
        XCTAssert([[rootObject objectForKey:@"headers"] isKindOfClass:[NSDictionary class]], @"headers class: %@", NSStringFromClass([[rootObject objectForKey:@"headers"] class]));
        XCTAssert([[rootObject objectForKey:@"json"] isKindOfClass:[NSNull class]], @"json class: %@", NSStringFromClass([[rootObject objectForKey:@"json"] class]));
        XCTAssert([[rootObject objectForKey:@"origin"] isKindOfClass:[NSString class]], @"origin class: %@", NSStringFromClass([[rootObject objectForKey:@"origin"] class]));
        XCTAssert([[rootObject objectForKey:@"url"] isKindOfClass:[NSString class]], @"url class: %@", NSStringFromClass([[rootObject objectForKey:@"url"] class]));
        
        NSDictionary *argObject = [rootObject objectForKey:@"args"];
        XCTAssert([argObject objectForKey:@"custname"] == inputName, @"customer name: %@", [argObject objectForKey:@"custname"]);
        
        NSDictionary *headersObject = [rootObject objectForKey:@"headers"];
        
        XCTAssert([headersObject objectForKey:@"Accept"] != nil, @"there's no object with key \"Accept\" existed");
        XCTAssert([headersObject objectForKey:@"Accept-Encoding"] != nil, @"there's no object with key \"Accept-Encoding\" existed");
        XCTAssert([headersObject objectForKey:@"Accept-Language"] != nil, @"there's no object with key \"Accept-Language\" existed");
        XCTAssert([headersObject objectForKey:@"Connection"] != nil, @"there's no object with key \"Connection\" existed");
        XCTAssert([headersObject objectForKey:@"Host"] != nil, @"there's no object with key \"Host\" existed");
        XCTAssert([headersObject objectForKey:@"User-Agent"] != nil, @"there's no object with key \"User-Agent\" existed");
        
        XCTAssert([[headersObject objectForKey:@"Accept"] isKindOfClass:[NSString class]], @"Accept class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept"] class]));
        XCTAssert([[headersObject objectForKey:@"Accept-Encoding"] isKindOfClass:[NSString class]], @"Accept-Encoding class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept-Encoding"] class]));
        XCTAssert([[headersObject objectForKey:@"Accept-Language"] isKindOfClass:[NSString class]], @"Accept-Language class: %@", NSStringFromClass([[headersObject objectForKey:@"Accept-Language"] class]));
        XCTAssert([[headersObject objectForKey:@"Connection"] isKindOfClass:[NSString class]], @"Connection class: %@", NSStringFromClass([[headersObject objectForKey:@"Connection"] class]));
        XCTAssert([[headersObject objectForKey:@"Host"] isKindOfClass:[NSString class]], @"Host class: %@", NSStringFromClass([[headersObject objectForKey:@"Host"] class]));
        XCTAssert([[headersObject objectForKey:@"User-Agent"] isKindOfClass:[NSString class]], @"User-Agent class: %@", NSStringFromClass([[headersObject objectForKey:@"User-Agent"] class]));
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
