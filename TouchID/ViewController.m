//
//  ViewController.m
//  TouchID
//
//  Created by crazypoo on 14/6/3.
//  Copyright (c) 2014年 crazypoo. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property (nonatomic, retain) LAContext *lol;
@property (nonatomic, retain) UIButton *dropButton;
@end

@implementation ViewController

@synthesize lol = _lol;
@synthesize dropButton = _dropButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dropButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dropButton.frame                      = CGRectMake(271, 100, 30, 30);
    self.dropButton.backgroundColor            = [UIColor purpleColor];
    [self.dropButton setTitle:@"點" forState:UIControlStateNormal];
    self.dropButton.layer.borderColor          = [UIColor clearColor].CGColor;
    self.dropButton.layer.borderWidth          = 2.0;
    self.dropButton.layer.cornerRadius         = 5.0;
    [self.dropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dropButton addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.dropButton];
    
}

-(void)dropDown:(id)sender
{
    LAContext *lol = [[LAContext alloc] init];
    
    NSError *hi = nil;
    NSString *hihihihi = @"asdhhkjhkjhkjhjhkjhkjhkjhkjhkjhkhkhkhkjh";
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&hi]) {
        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:hihihihi reply:^(BOOL succes, NSError *error)
         {
             if (succes) {
                 NSLog(@"yes");
             }
             else
             {
                 NSLog(@"no");
             }
         }];
    }
    else
    {
        NSLog(@"yamiedie");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
