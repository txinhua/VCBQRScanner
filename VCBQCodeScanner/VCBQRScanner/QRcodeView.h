//
//  QRcodeView.h
//  CaputerDemo
//
//  Created by VcaiTech on 16/7/11.
//  Copyright © 2016年 VcaiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureOutput.h>

@class AVCaptureDevice, AVCaptureDeviceInput, AVCaptureMetadataOutput, AVCaptureSession, AVCaptureVideoPreviewLayer, NSString, NSTimer, UIButton, UIImageView, UILabel;

@interface QRcodeView : UIView<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
    UIView *_maskView;
    UIView *_leftView;
    UIView *_bottomView;
    UIView *_rightView;
    UIView *_topView;
    
    BOOL isQrflag;
    BOOL torchIsOn;
    UIView *_menuView;
    UIImageView *_qrImage;
    UILabel *_qrText;
    
    UIImageView *_barCodeImage;
    UILabel *_barCodeText;
    
    UIImageView *_torchImage;
    UILabel *_torchText;
    
    UILabel *sucessTip;
    
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
    UIImageView *_line;
    
}

@property(retain, nonatomic) AVCaptureDevice *device;
@property(retain, nonatomic) AVCaptureDeviceInput *input; // @synthesize input=_input;
@property(retain, nonatomic) UIImageView *line; // @synthesize line=_line;
@property(retain, nonatomic) AVCaptureMetadataOutput *output; // @synthesize output=_output;
@property(retain, nonatomic) AVCaptureVideoPreviewLayer *preview; // @synthesize preview=_preview;
@property(retain, nonatomic) AVCaptureSession *session; // @synthesize session=_session;
- (void)startCamera;
- (void)pauseCamera;
- (void)stopCamera;

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;
// Remaining properties
@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end
