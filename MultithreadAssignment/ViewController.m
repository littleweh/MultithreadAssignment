//
//  ViewController.m
//  WebServiceSDK
//
//  Created by Ada Kao on 25/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ViewController.h"
#import "ASWebServiceSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ASWebServiceSDK sharedInstance] fetchGetResponseWithCallback:^(NSDictionary *result, NSError *error) {
        NSLog(@"args: %@", [result objectForKey:@"args"]);
        NSLog(@"headers: %@", [result objectForKey:@"headers"]);
        NSLog(@"origin: %@", [result objectForKey:@"origin"]);
        NSLog(@"url: %@", [result objectForKey:@"url"]);
    }];

    [[ASWebServiceSDK sharedInstance] postCustomerName:@"test" callback:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", result);
        }
    }];

    [[ASWebServiceSDK sharedInstance] fetchImageWithCallback:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(30, 30, 100, 100);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
