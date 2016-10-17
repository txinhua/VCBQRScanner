//
//  ViewController.m
//  VCBQCodeScanner
//
//  Created by VcaiTech on 2016/10/17.
//  Copyright © 2016年 Tang guifu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanQRViewController.h"


@interface ViewController ()<QRResultDelegate>
@end


@implementation ViewController

- (IBAction)doScan:(id)sender {
    
    ScanQRViewController *scanViewController =[[ScanQRViewController alloc]init];
    
    scanViewController.delegate = self;
    
    [self presentViewController:scanViewController animated:YES completion:nil];
    
}

-(void)qrDelegateResult:(NSString *)resultStr{
    
    NSLog(@"%@",resultStr);
    
//    UIAlertView *qrAlert  = [[UIAlertView alloc]initWithTitle:@"Scaner Result" message:resultStr delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
//    
//    [qrAlert show];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
