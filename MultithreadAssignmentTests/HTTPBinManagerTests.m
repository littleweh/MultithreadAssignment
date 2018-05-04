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


@interface HTTPBinManagerTests : XCTestCase <HTTPBinManagerDelegate>
@property (strong, nonatomic) XCTestExpectation *expectation100;
@property (strong ,nonatomic) XCTestExpectation *expectationForFail;
@property (assign, nonatomic) HTTPBinManagerOperationStatus status;
@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray <NSDictionary *> * objects;
@end

@interface ASWebServiceSDK ()
@property (strong, nonatomic, readwrite) NSString * fetchGetURLString;
@property (strong, nonatomic, readwrite) NSString * postCustNameURLString;
@property (strong, nonatomic, readwrite) NSString * fetchImageURLString;
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
    
    ASWebServiceSDK *sdk = [[ASWebServiceSDK alloc] init];
    
    HTTPBinManagerOperation * operation = [[HTTPBinManagerOperation alloc] init];
    [operation setSdk:sdk];
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
-(void) testExecuteOperationFailedOnFirst {
    self.expectationForFail = [self expectationWithDescription:@"executeOperation failed on first"];
    self.status = httpBinManagerOperationBegin;
    self.progress = 0.0;
    
    ASWebServiceSDK *sdk = [[ASWebServiceSDK alloc]init];
    [sdk setFetchGetURLString:@"get none"];
    
    HTTPBinManagerOperation * operation = [[HTTPBinManagerOperation alloc] init];
    [operation setSdk:sdk];
    
    [[HTTPBinManager sharedInstance] setDelegate:self];
    [[HTTPBinManager sharedInstance] executeOperation:operation];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    XCTAssert(self.status == httpBinManagerOperationFail, @"status: %ld", (unsigned long) self.status);
    XCTAssert(self.progress == 0.0, @"progress: %f", self.progress);

}

-(void) testExecuteOperationFailedOnSecond {
    self.expectationForFail = [self expectationWithDescription:@"executeOperation failed on first"];
    self.status = httpBinManagerOperationBegin;
    self.progress = 0.0;
    
    ASWebServiceSDK *sdk = [[ASWebServiceSDK alloc]init];
    [sdk setPostCustNameURLString:@"post custName none"];
    
    HTTPBinManagerOperation * operation = [[HTTPBinManagerOperation alloc] init];
    [operation setSdk:sdk];
    
    [[HTTPBinManager sharedInstance] setDelegate:self];
    [[HTTPBinManager sharedInstance] executeOperation:operation];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    XCTAssert(self.status == httpBinManagerOperationFail, @"status: %ld", (unsigned long) self.status);
    XCTAssert(self.progress == 33.0, @"progress: %f", self.progress);
    
}

-(void) testExecuteOperationFailedOnThird {
    self.expectationForFail = [self expectationWithDescription:@"executeOperation failed on first"];
    self.status = httpBinManagerOperationBegin;
    self.progress = 0.0;
    
    ASWebServiceSDK *sdk = [[ASWebServiceSDK alloc]init];
    [sdk setFetchImageURLString:@"get image none"];
    
    HTTPBinManagerOperation * operation = [[HTTPBinManagerOperation alloc] init];
    [operation setSdk:sdk];
    
    [[HTTPBinManager sharedInstance] setDelegate:self];
    [[HTTPBinManager sharedInstance] executeOperation:operation];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    XCTAssert(self.status == httpBinManagerOperationFail, @"status: %ld", (unsigned long) self.status);
    XCTAssert(self.progress == 66.0, @"progress: %f", self.progress);
    
}

#pragma mark - HTTPBinManagerDelegate method
- (void)httpBinManager:(HTTPBinManager *)manager didGetObject:(NSArray<NSDictionary *> *)objects didGetImage:(UIImage *)image {
    self.objects = objects;
    self.image = image;
    [self.expectation100 fulfill];
}

- (void)httpBinManager:(HTTPBinManager *)manager status:(HTTPBinManagerOperationStatus)statusCode progress:(CGFloat)progressPercentage {
    self.status = statusCode;
    self.progress = progressPercentage;
    if (self.status == httpBinManagerOperationFail) {
        [self.expectationForFail fulfill];
    }
}

@end
