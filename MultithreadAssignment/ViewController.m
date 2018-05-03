//
//  ViewController.m
//  WebServiceSDK
//
//  Created by Ada Kao on 25/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ViewController.h"
#import "ASWebServiceSDK.h"
#import "HTTPBinManager.h"
#import "HTTPBinManagerOperation.h"

@interface ViewController () <HTTPBinManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[ASWebServiceSDK sharedInstance] fetchGetResponseWithCallback:^(NSDictionary *result, NSError *error) {
//        NSLog(@"args: %@", [result objectForKey:@"args"]);
//        NSLog(@"headers: %@", [result objectForKey:@"headers"]);
//        NSLog(@"origin: %@", [result objectForKey:@"origin"]);
//        NSLog(@"url: %@", [result objectForKey:@"url"]);
//    }];
//
//    [[ASWebServiceSDK sharedInstance] postCustomerName:@"test" callback:^(NSDictionary *result, NSError *error) {
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//        } else {
//            NSLog(@"%@", result);
//        }
//    }];
//
//    [[ASWebServiceSDK sharedInstance] fetchImageWithCallback:^(UIImage *image, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//            imageView.frame = CGRectMake(30, 30, 100, 100);
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [self.view addSubview:imageView];
//        });
//    }];
    
    HTTPBinManagerOperation *operation = [[HTTPBinManagerOperation alloc] init];
    HTTPBinManager *manager = [HTTPBinManager sharedInstance];
    [manager setDelegate:self];
    [manager executeOperation:operation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    NSLog(@"ViewController dealloc");
}


- (void)httpBinManager:(HTTPBinManager *)manager didGetObject:(NSArray<NSDictionary *> *)objects didGetImage:(UIImage *)image {
    for (NSDictionary * object in objects) {
        NSLog(@"%@", object);
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(30, 30, 100, 100);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}

- (void)httpBinManager:(HTTPBinManager *)manager progress:(CGFloat)progressPercentage {
    NSLog(@"%f", progressPercentage);
}

- (void)httpBinManager:(HTTPBinManager *)manager status:(HTTPBinManagerOperationStatus)statusCode {
    NSLog(@"%lu", (unsigned long)statusCode);
}



@end
