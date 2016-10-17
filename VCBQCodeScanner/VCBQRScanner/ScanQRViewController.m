//
//  ScanQRViewController.m
//  CaputerDemo
//
//  Created by VcaiTech on 16/7/11.
//  Copyright © 2016年 VcaiTech. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRcodeView.h"

@interface ScanQRViewController ()

@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _codeView =[[QRcodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_codeView];
    
    [_codeView startCamera];
    
//    __weak QRcodeView *weakCodeView = _codeView;
    
    __weak ScanQRViewController *weakSelf = self;
    
    [_codeView setCompletionWithBlock:^(NSString *resultAsString){
        
        if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(qrDelegateResult:)]){
            
            [weakSelf.delegate performSelector:@selector(qrDelegateResult:) withObject:resultAsString];
            
        }
//        [weakCodeView stopCamera];
//        
//        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
