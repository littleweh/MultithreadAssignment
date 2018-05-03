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
@property (strong, nonatomic, readwrite) UIProgressView * progressView;
@property (strong, nonatomic, readwrite) UIButton *button;
@property (strong, nonatomic, readwrite) UILabel *label;
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
    

    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.label = [[UILabel alloc] init];
    self.progressView = [[UIProgressView alloc] init];
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    [self.view addSubview:self.progressView];
    
    [self setupProgressView];
    [self setupLabel];
    [self setupButton];
}

-(void) setupProgressView {
    [self.progressView setProgress:50.0];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = [UIColor blackColor];
    self.progressView.trackTintColor = [UIColor orangeColor];
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.progressView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.progressView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.progressView
                                                               attribute:NSLayoutAttributeTrailing
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeTrailing
                                                              multiplier:1.0
                                                                constant:-30.0];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.progressView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:30.0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.progressView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:20.0];
    
    [self.view addConstraint:centerX];
    [self.view addConstraint:centerY];
    [self.view addConstraint:trailing];
    [self.view addConstraint:leading];
    [self.progressView addConstraint:height];
    
}

-(void)setupButton {
    [self.button addTarget:self
                    action:@selector(buttonTapped)
          forControlEvents:UIControlEventTouchUpInside
     ];
    
    [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor blackColor];
    [self.button setTitle:@"send data request" forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.button sizeToFit];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.button
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.progressView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:10.0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.button
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.button
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:-120.0];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.button
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:120.0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.button
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:28.0];
    
    [self.view addConstraint:centerX];
    [self.view addConstraint:trailing];
    [self.view addConstraint:leading];
    [self.button addConstraint:height];
    [self.view addConstraint:top];
    
}

-(void)setupLabel {
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.label setText:@"Progress"];
    [self.label setTextColor:[UIColor orangeColor]];
    [self.label setFont:[UIFont systemFontOfSize:24]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.label sizeToFit];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.label
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.progressView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:-10.0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.label
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:-120.0];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:120.0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:28.0];
    
    [self.view addConstraint:centerX];
    [self.view addConstraint:trailing];
    [self.view addConstraint:leading];
    [self.label addConstraint:height];
    [self.view addConstraint:bottom];
    
}

-(void) buttonTapped {
    [self.button setEnabled:NO];
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


#pragma mark - HTTPBinManagerDelegate method implement

- (void)httpBinManager:(HTTPBinManager *)manager didGetObject:(NSArray<NSDictionary *> *)objects didGetImage:(UIImage *)image {
    for (NSDictionary * object in objects) {
        NSLog(@"%@", object);
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(30, 30, 100, 100);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    [self.button setEnabled:YES];
}

- (void)httpBinManager:(HTTPBinManager *)manager progress:(CGFloat)progressPercentage {
    NSLog(@"%f", progressPercentage);
    [self.progressView setProgress:progressPercentage / 100.0 animated:YES];
}

- (void)httpBinManager:(HTTPBinManager *)manager status:(HTTPBinManagerOperationStatus)statusCode {
    NSLog(@"status: %lu", (unsigned long)statusCode);
}



@end
