//
//  QRcodeView.m
//  CaputerDemo
//
//  Created by VcaiTech on 16/7/11.
//  Copyright © 2016年 VcaiTech. All rights reserved.
//

#import "QRcodeView.h"
#import <AVFoundation/AVFoundation.h>
#define SCANBOXSIZE 210
#define TOPVIEWHEIGHT 96
#define CORSIZE   20
#define LINEHEIGHT 6

@implementation QRcodeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isQrflag = YES;
        [self setupView];
        [self setupCamera];
        [timer fire];
    }
    return self;
}

-(void)showScannerSucessTip{
    
    [self pauseCamera];
    __weak QRcodeView *weakSelf = self;
    __weak UILabel *weakTipLabel =sucessTip;
    [UIView animateWithDuration:0.5 animations:^{
        weakTipLabel.alpha = 1;
    } completion:^(BOOL finished) {
        __strong QRcodeView *strongSelf = weakSelf;
        __strong UILabel    *strongTipLabel = weakTipLabel;
        [UIView animateWithDuration:0.5 animations:^{
            strongTipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [strongSelf reStartCamera];
        }];
    }];
}

-(void)setupView{
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _maskView.backgroundColor =[UIColor clearColor];
    [self addSubview:_maskView];
    
    
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.frame.size.width-SCANBOXSIZE)*0.5, self.frame.size.height)];
    _leftView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [_maskView addSubview:_leftView];
    
    _rightView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-(self.frame.size.width-SCANBOXSIZE)*0.5, 0, (self.frame.size.width-SCANBOXSIZE)*0.5, self.frame.size.height)];
    _rightView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [_maskView addSubview:_rightView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, 0, SCANBOXSIZE, TOPVIEWHEIGHT)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [_maskView addSubview:_topView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT+SCANBOXSIZE, SCANBOXSIZE, self.frame.size.height-(TOPVIEWHEIGHT+SCANBOXSIZE))];
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [_maskView addSubview:_bottomView];
    
    UIImageView *topLeftImage =[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT, CORSIZE, CORSIZE)];
    [topLeftImage setImage:[UIImage imageNamed:@"scan_case"]];
    [_maskView addSubview:topLeftImage];
    
    UIImageView *topRightImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-((self.frame.size.width-SCANBOXSIZE)*0.5+CORSIZE), TOPVIEWHEIGHT, CORSIZE, CORSIZE)];
    [topRightImage setImage:[UIImage imageNamed:@"scan_case"]];
    topRightImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:topRightImage];
    
    UIImageView *bottomLeftImage =[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT+SCANBOXSIZE-CORSIZE, CORSIZE, CORSIZE)];
    [bottomLeftImage setImage:[UIImage imageNamed:@"scan_case"]];
    bottomLeftImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:bottomLeftImage];
    
    UIImageView *bottomRightImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-((self.frame.size.width-SCANBOXSIZE)*0.5+CORSIZE), TOPVIEWHEIGHT+SCANBOXSIZE-CORSIZE, CORSIZE, CORSIZE)];
    [bottomRightImage setImage:[UIImage imageNamed:@"scan_case"]];
    bottomRightImage.transform = CGAffineTransformMakeRotation(M_PI);
    [_maskView addSubview:bottomRightImage];
    
    _line = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT, SCANBOXSIZE, LINEHEIGHT)];
    [_line setImage:[UIImage imageNamed:@"scan_line"]];
    [_maskView addSubview:_line];
    _line.alpha = 0;
    
    
    CGFloat menuItemSpace = (self.frame.size.width-120)*0.25;
    CGFloat menuHegith = 80;
    CGFloat menuItemHeight = 60;
    CGFloat menuItemWidth = 40;
    _menuView =[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.frame.size.height-menuHegith, _maskView.frame.size.width, menuHegith)];
   _menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
   [_maskView addSubview:_menuView];
    
    CGRect imageRect = CGRectMake(5, 0, menuItemWidth-10, menuItemWidth-10);
    
    CGRect textRect = CGRectMake(0, menuItemWidth-5, menuItemWidth, 20);
    
    UIView *menuItemQR = [[UIView alloc]initWithFrame:CGRectMake(menuItemSpace,(menuHegith-menuItemHeight)*0.5, menuItemWidth, menuItemHeight)];
    menuItemQR.backgroundColor =[UIColor clearColor];
    [_menuView addSubview:menuItemQR];
    
    _qrImage =[[UIImageView alloc]initWithFrame:imageRect];
    [_qrImage setImage:[UIImage imageNamed:isQrflag?@"qr_sel":@"qr_unsel"]];
    [menuItemQR addSubview:_qrImage];
    
    _qrText =[[UILabel alloc]initWithFrame:textRect];
    _qrText.backgroundColor =[UIColor clearColor];
    _qrText.textAlignment = NSTextAlignmentCenter;
    _qrText.font =[UIFont systemFontOfSize:12];
    _qrText.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:isQrflag?@"sel_color":@"unselclolr"]];
    _qrText.text = @"二维码";
    [menuItemQR addSubview:_qrText];
    
    
    UIButton *qrbutton =[UIButton buttonWithType:UIButtonTypeCustom];
    [qrbutton setFrame:menuItemQR.frame];
    [_menuView addSubview:qrbutton];
    [qrbutton setExclusiveTouch:YES];
    [qrbutton addTarget:self action:@selector(qrSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *menuItemBarCode = [[UIView alloc]initWithFrame:CGRectMake(menuItemSpace*2+menuItemWidth,(menuHegith-menuItemHeight)*0.5, menuItemWidth, menuItemHeight)];
    menuItemBarCode.backgroundColor =[UIColor clearColor];
    [_menuView addSubview:menuItemBarCode];
    
    _barCodeImage =[[UIImageView alloc]initWithFrame:imageRect];
    
    [_barCodeImage setImage:[UIImage imageNamed:isQrflag?@"barcode_unsel":@"barcode_sel"]];
    
    [menuItemBarCode addSubview:_barCodeImage];
    
    _barCodeText =[[UILabel alloc]initWithFrame:textRect];
    _barCodeText.backgroundColor =[UIColor clearColor];
    _barCodeText.textAlignment = NSTextAlignmentCenter;
    _barCodeText.font =[UIFont systemFontOfSize:12];
    _barCodeText.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:isQrflag?@"unselclolr":@"sel_color"]];
    
    _barCodeText.text = @"条形码";
    
    [menuItemBarCode addSubview:_barCodeText];
    
    UIButton *barCodebutton =[UIButton buttonWithType:UIButtonTypeCustom];
    [barCodebutton setFrame:menuItemBarCode.frame];
    [_menuView addSubview:barCodebutton];
    [barCodebutton addTarget:self action:@selector(barCodeSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *menuItemTorch = [[UIView alloc]initWithFrame:CGRectMake(menuItemSpace*3+menuItemWidth*2,(menuHegith-menuItemHeight)*0.5, menuItemWidth, menuItemHeight)];
    menuItemTorch.backgroundColor =[UIColor clearColor];
    [_menuView addSubview:menuItemTorch];
    
    _torchImage =[[UIImageView alloc]initWithFrame:imageRect];
    [_torchImage setImage:[UIImage imageNamed:torchIsOn?@"glim_on":@"glim_off"]];
    [menuItemTorch addSubview:_torchImage];
    
    
    _torchText =[[UILabel alloc]initWithFrame:textRect];
    _torchText.backgroundColor =[UIColor clearColor];
    _torchText.textAlignment = NSTextAlignmentCenter;
    _torchText.font =[UIFont systemFontOfSize:12];
    _torchText.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sel_color"]];
    _torchText.text = @"灯光";
    [menuItemTorch addSubview:_torchText];
    
    UIButton *torchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [torchButton setFrame:menuItemTorch.frame];
    [_menuView addSubview:torchButton];
    [torchButton addTarget:self action:@selector(torchSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    sucessTip =[[UILabel alloc]initWithFrame:CGRectMake(0,TOPVIEWHEIGHT-30, _maskView.frame.size.width, 20)];
    sucessTip.backgroundColor =[UIColor clearColor];
    sucessTip.textAlignment = NSTextAlignmentCenter;
    sucessTip.font =[UIFont systemFontOfSize:16];
    sucessTip.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sel_color"]];
    sucessTip.text = @"录入成功";
    sucessTip.alpha = 0;
    [_maskView addSubview:sucessTip];
    
}



-(void)qrSelected{
    if (!isQrflag) {
        isQrflag  = YES;
        UIImage *barImage = [UIImage imageNamed:@"barcode_unsel"];
        [_barCodeImage setImage:barImage];
        _barCodeText.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"unselclolr"]];
        
        UIImage *qImage = [UIImage imageNamed:@"qr_sel"];
        [_qrImage setImage:qImage];
        _qrText.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"sel_color"]];
        [self reSetMediaType];
    }
}

-(void)barCodeSelected{
    if (isQrflag) {
        isQrflag  = NO;
        UIImage *barImage = [UIImage imageNamed:@"barcode_sel"];
        [_barCodeImage setImage:barImage];
        _barCodeText.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"sel_color"]];
        
        UIImage *qImage = [UIImage imageNamed:@"qr_unsel"];
        [_qrImage setImage:qImage];
        _qrText.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"unselclolr"]];
        [self reSetMediaType];
    }
}

-(void)torchSwitch{
    if ([self isTorchAvailable]) {
        torchIsOn=!torchIsOn;
        [_torchImage setImage:[UIImage imageNamed:torchIsOn?@"glim_on":@"glim_off"]];
        [self toggleTorch];
    }
}


-(void)reSetMediaType{
    [self pauseCamera];
    [_output setMetadataObjectTypes:isQrflag?@[AVMetadataObjectTypeQRCode]:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    [self reStartCamera];
}

- (void)setupCamera{
    num = 3;
    timer = [NSTimer timerWithTimeInterval:num target:self selector:@selector(animationLoopLines) userInfo:nil repeats:YES];
    [self setupAVComponents];
    [self configureDefaultComponents];
}

-(void)animationLoopLines{
    [_line setFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT, SCANBOXSIZE, LINEHEIGHT)];
    _line.alpha = 1.0;
    [UIView animateWithDuration:num animations:^{
       [_line setFrame:CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT+SCANBOXSIZE-LINEHEIGHT, SCANBOXSIZE, LINEHEIGHT)];
    } completion:^(BOOL finished) {
        _line.alpha = 0;
        [timer fire];
    }];
}

-(void)startCamera{
    
    if (_line) {
        _line.alpha = 1;
    }
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
}

-(void)reStartCamera{
    if (_line) {
        _line.alpha = 1;
    }
    if (![self.session isRunning]) {
        [self toggleTorch];
        [self.session startRunning];
    }
    
}

-(void)pauseCamera{
    if (_line) {
        _line.alpha = 0;
    }
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)stopCamera{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if (_line) {
       _line.alpha = 0;
    }
    if(timer){
        [timer invalidate];
    }
}





- (void)setupAVComponents
{
    //step1: 初始化图像输入设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_device) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        self.output     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.preview       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.preview setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
}

- (void)configureDefaultComponents
{
    [_session addOutput:_output];
    
    if (_input) {
        [_session addInput:_input];
    }
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [_output setMetadataObjectTypes:isQrflag?@[AVMetadataObjectTypeQRCode]:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    //设置只在小矩形框中获取到图像才有效，否则为无效
    CGSize size = self.bounds.size;
    CGRect cropRect = CGRectMake((self.frame.size.width-SCANBOXSIZE)*0.5, TOPVIEWHEIGHT, SCANBOXSIZE, SCANBOXSIZE);
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                  cropRect.origin.x/size.width,
                                                  cropRect.size.height/fixHeight,
                                                  cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                  (cropRect.origin.x + fixPadding)/fixWidth,
                                                  cropRect.size.height/size.height,
                                                  cropRect.size.width/fixWidth);
    }
    
    [_preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.layer insertSublayer:_preview atIndex:0];
}


- (BOOL)isTorchAvailable
{
    return _device.hasTorch;
}

- (void)toggleTorch
{
    NSError *error = nil;
    
    [_device lockForConfiguration:&error];
    
    if (error == nil) {
        
//        AVCaptureTorchMode mode = _device.torchMode;
        _device.torchMode = torchIsOn? AVCaptureTorchModeOn:AVCaptureTorchModeOff;
        
    }
    
    [_device unlockForConfiguration];
}

#pragma mark - Controlling Reader

- (BOOL)running {
    
    return self.session.running;
    
}


#pragma mark - Managing the Orientation

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - Checking the Reader Availabilities

+ (BOOL)isAvailable
{
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        return YES;
    }
}

+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    if (![self isAvailable]) {
        return NO;
    }
    
    @autoreleasepool {
        // Setup components
        AVCaptureDevice *captureDevice    = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        AVCaptureMetadataOutput *output   = [[AVCaptureMetadataOutput alloc] init];
        AVCaptureSession *session         = [[AVCaptureSession alloc] init];
        
        [session addInput:deviceInput];
        [session addOutput:output];
        
        if (metadataObjectTypes == nil || metadataObjectTypes.count == 0) {
            
            // Check the QRCode metadata object type by default
//            metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            
            metadataObjectTypes =  @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            
        }
        
        for (NSString *metadataObjectType in metadataObjectTypes) {
            if (![output.availableMetadataObjectTypes containsObject:metadataObjectType]) {
                return NO;
            }
        }
        
        return YES;
    }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{   
    self.completionBlock = completionBlock;
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code] containsObject:current.type]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            if (_completionBlock) {
                _completionBlock(scannedResult);
            }
            [self showScannerSucessTip];
            break;
        }
    }
}

@end
