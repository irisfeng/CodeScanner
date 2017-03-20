//
//  SZQRCodeViewController.m
//  SZQRCodeViewController
//
//  Created by Stephen Zhuang on 16/5/17.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

#import "SZQRCodeViewController.h"
#import "PureLayout.h"
#import "detailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SZQRCodeViewController (){
    
    AVAudioPlayer *audioPlayer;
}
@end

@implementation SZQRCodeViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//- (UIActivityIndicatorView *)indicator {
//    if (!_indicator) {
//        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    }
//    return _indicator;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"测试";
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中授权访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        
        hasCameraRight = NO;
        return;
    }
    hasCameraRight = YES;
    
//    self.indicator.center = self.view.center;
//    [self.view addSubview:self.indicator];
    
    // prepare the di sound
    NSString *path = [NSString stringWithFormat:@"%@/didi.mp3",[[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    // setup camera
    [self setupCamera];

}

//the scan line looking animation
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (2 * num == CGRectGetHeight(imageView.frame) - 20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (BOOL)navigationShouldPopOnBackButton
{
    [timer invalidate];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.indicator stopAnimating];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.8 * self.view.frame.size.width, 0.8 * self.view.frame.size.width)];
    imageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:imageView];
    [imageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [imageView autoSetDimensionsToSize:CGSizeMake(0.8 * self.view.frame.size.width, 0.8 * self.view.frame.size.width)];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"将取景框对准各种码，即自动扫描";
    [self.view addSubview:labIntroudction];
    [labIntroudction autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView];
    [labIntroudction autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView];
    [labIntroudction autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:8];
    
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    [_line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView withOffset:40];
    [_line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView withOffset:-40];
    [_line autoSetDimension:ALDimensionHeight toSize:2];
    [_line autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView withOffset:10];

    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

- (void)setupCamera
{
    
//    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc] init];
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeAztecCode,
                                       AVMetadataObjectTypePDF417Code];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [_session stopRunning];
        [timer invalidate];
//        NSLog(@"%@",stringValue);
        
        if (stringValue.length > 0) {

            // play the di sound.
            
            [audioPlayer play];
            
            // preform segue
            [self performSegueWithIdentifier:@"detailVC" sender:stringValue];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
//            }
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    detailViewController *detailVC = (detailViewController *)segue.destinationViewController;
    NSString *codeResultString = (NSString* )sender;
    detailVC.codeOutString = codeResultString;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
