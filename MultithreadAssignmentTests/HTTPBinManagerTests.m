//
//  HTTPBinManagerOperationTests.m
//  MultithreadAssignmentTests
//
//  Created by Ada Kao on 02/05/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPBinManager.h"
#import "ASWebServiceSDK.h"

static NSString *const endPointGet = @"ge";

@interface HTTPBinManagerTests : XCTestCase <HTTPBinManagerDelegate>
@property (strong, nonatomic) XCTestExpectation *expectation100;
@property (assign, nonatomic) HTTPBinManagerOperationStatus status;
@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray <NSDictionary *> * objects;
@end



@implementation HTTPBinManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testExecuteOperationSuccess {
    self.expectation100 = [self expectationWithDescription:@"executeOperation success"];
    self.status = httpBinManagerOperationBegin;
    self.progress = 0.0;
    
    HTTPBinManagerOperation * operation = [[HTTPBinManagerOperation alloc] init];
    [[HTTPBinManager sharedInstance] setDelegate:self];
    [[HTTPBinManager sharedInstance] executeOperation:operation];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    XCTAssert(self.status == httpBinManagerOperationSuccess, @"status: %ld", (unsigned long) self.status);
    XCTAssert(self.progress == 100.0, @"progress: %f", self.progress);
    XCTAssert([self.image isKindOfClass:[UIImage class]], @"image should be UIImage type");
    XCTAssert([self.objects[0] isKindOfClass:[NSDictionary class]], @"objects[0] should be NSDictionary type");
    XCTAssert([self.objects[1] isKindOfClass:[NSDictionary class]], @"objects[1] should be NSDictionary type");
}

- (void)httpBinManager:(HTTPBinManager *)manager didGetObject:(NSArray<NSDictionary *> *)objects didGetImage:(UIImage *)image {
    self.objects = objects;
    self.image = image;
    [self.expectation100 fulfill];
}

- (void)httpBinManager:(HTTPBinManager *)manager progress:(CGFloat)progressPercentage {
    self.progress = progressPercentage;
}

- (void)httpBinManager:(HTTPBinManager *)manager status:(HTTPBinManagerOperationStatus)statusCode {
    self.status = statusCode;
}

@end
