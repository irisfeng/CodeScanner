//
//  DeviceDetailViewController.h
//  SZQRCodeViewController
//
//  Created by iris feng on 2017/3/28.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface DeviceDetailViewController : UIViewController
//@property (strong, nonatomic) AVObject *device;
@property (weak, nonatomic) NSString *codeOutString;
@end
