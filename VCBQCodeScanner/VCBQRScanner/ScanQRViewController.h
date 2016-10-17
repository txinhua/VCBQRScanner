//
//  ScanQRViewController.h
//  CaputerDemo
//
//  Created by VcaiTech on 16/7/11.
//  Copyright © 2016年 VcaiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRResultDelegate <NSObject>
-(void)qrDelegateResult:(NSString *)resultStr;
@end

@class QRcodeView;

@interface ScanQRViewController : UIViewController

@property(nonatomic,strong)QRcodeView *codeView;
@property(nonatomic,assign)id<QRResultDelegate>delegate;

@end

