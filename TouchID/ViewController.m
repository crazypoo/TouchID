//
//  ViewController.m
//  TouchID
//
//  Created by crazypoo on 14/6/3.
//  Copyright (c) 2014年 crazypoo. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>

@interface ViewController ()<NSURLSessionDelegate,UITextViewDelegate>
@property (nonatomic, retain) UIButton *dropButton;
@property (nonatomic, retain) NSURLSession *mySession;
@property (nonatomic, retain) UIButton *dropButton1;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIButton *dropButton2;
@property (nonatomic, retain) NSString *strBeDelete;
@end

@implementation ViewController

@synthesize dropButton = _dropButton;
@synthesize dropButton1 = _dropButton1;
@synthesize textView = _textView;
@synthesize dropButton2 = _dropButton2;
@synthesize strBeDelete = _strBeDelete;

-(void)viewDidAppear:(BOOL)animated
{
//TODO:其实只需要加载一次就可以了
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject;
    sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                kSecAccessControlUserPresence, &error);
    if(sacObject == NULL || error != NULL)
    {
        NSLog(@"can't create sacObject: %@", error);
        self.textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_ADD_CAN_CREATE_OBJECT", nil), error]];
        return;
    }
    
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"SampleService",
                                 (__bridge id)kSecValueData: [@"SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding],
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_ADD_STATUS", nil), [self keychainErrorToString:status]];
        [self printResult:self.textView message:msg];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dropButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dropButton.frame                      = CGRectMake(self.view.frame.size.width - 60, 100, 60, 60);
    self.dropButton.backgroundColor            = [UIColor purpleColor];
    [self.dropButton setTitle:@"指纹" forState:UIControlStateNormal];
    self.dropButton.layer.borderColor          = [UIColor clearColor].CGColor;
    self.dropButton.layer.borderWidth          = 2.0;
    self.dropButton.layer.cornerRadius         = 5.0;
    [self.dropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dropButton addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.dropButton];
    
    self.dropButton1                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dropButton1.frame                      = CGRectMake(0, 100, 60, 60);
    self.dropButton1.backgroundColor            = [UIColor purpleColor];
    [self.dropButton1 setTitle:@"密码" forState:UIControlStateNormal];
    self.dropButton1.layer.borderColor          = [UIColor clearColor].CGColor;
    self.dropButton1.layer.borderWidth          = 2.0;
    self.dropButton1.layer.cornerRadius         = 5.0;
    [self.dropButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropButton1.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dropButton1 addTarget:self action:@selector(tapkey) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.dropButton1];
    
    self.dropButton2                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dropButton2.frame                      = CGRectMake(self.view.frame.size.width/2 - 30, 100, 60, 60);
    self.dropButton2.backgroundColor            = [UIColor purpleColor];
    [self.dropButton2 setTitle:@"清除" forState:UIControlStateNormal];
    self.dropButton2.layer.borderColor          = [UIColor clearColor].CGColor;
    self.dropButton2.layer.borderWidth          = 2.0;
    self.dropButton2.layer.cornerRadius         = 5.0;
    [self.dropButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropButton2.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dropButton2 addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.dropButton2];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.userInteractionEnabled = NO;
    [self.view addSubview:self.textView];

    
}

-(void)dropDown:(id)sender
{
    LAContext *lol = [[LAContext alloc] init];
    
    NSError *hi = nil;
    NSString *hihihihi = @"验证XXXXXX";
//TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&hi]) {
//TODO:TOUCHID开始运作
        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:hihihihi reply:^(BOOL succes, NSError *error)
         {
             if (succes) {
                 NSLog(@"yes");
             }
             else
             {
                 NSString *str = [NSString stringWithFormat:@"%@",error.localizedDescription];
                 if ([str isEqualToString:@"Tapped UserFallback button."]) {
                     if ([self.strBeDelete isEqualToString:@"SEC_ITEM_DELETE_STATUS"]) {
                         NSLog(@"密码被清空了");
                     }
                     else
                     {
                         [self tapkey];
                     }
                 }
                 else
                 {
                     NSLog(@"你取消了验证");
                 }
             }
         }];

    }
    else
    {
        NSLog(@"没有开启TOUCHID设备自行解决");
    }
    
}

-(void)delete
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService"
                            };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
        
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_DELETE_STATUS", nil), [self keychainErrorToString:status]];
        [self printResult:self.textView message:msg];
        self.strBeDelete = [NSString stringWithFormat:@"%@",msg];
    });
}

-(void)tapkey
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService",
                            (__bridge id)kSecUseOperationPrompt: @"用你本机密码验证登陆"
                            };
    
    NSDictionary *changes = @{
                              (__bridge id)kSecValueData: [@"UPDATED_SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding]
                              };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_UPDATE_STATUS", nil), [self keychainErrorToString:status]];
        [self printResult:self.textView message:msg];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printResult:(UITextView*)textView message:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",msg]];
        [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    });
}

- (NSString *)keychainErrorToString: (NSInteger)error
{
    
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case -26276:
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            
        default:
            break;
    }
    
    return msg;
}
@end
