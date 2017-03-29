//
//  DeviceDetailViewController.m
//  SZQRCodeViewController
//
//  Created by iris feng on 2017/3/28.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *taizhangCode;
@property (weak, nonatomic) IBOutlet UILabel *deviceType;
@property (weak, nonatomic) IBOutlet UITextView *detailDescription;
@property (weak, nonatomic) IBOutlet UILabel *ipAdress;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation DeviceDetailViewController

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}


- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [_indicator startAnimating];
    NSLog(@"%@",self.codeOutString);
    
    self.detailDescription.opaque  = false;
    self.detailDescription.backgroundColor = [UIColor clearColor];
    
    [self updateUI];
    [_indicator stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"DeviceDetailView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"DeviceDetailView"];
}

- (void) updateUI {
    
//    self.detailDescription.editable = YES;
//    self.detailDescription.font = [UIFont systemFontOfSize:17.0f];
//    self.detailDescription.editable = NO;
    

//    self.device = [AVObject objectWithClassName:@"Device"];
    AVQuery *query = [AVQuery queryWithClassName:@"Device"];
    [query whereKey:@"assetCode" equalTo:self.codeOutString];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (error) {
            printf("ERROR!!未找到适配设备");
            self.deviceName.hidden = true;
            self.taizhangCode.hidden = true;
            self.deviceType .hidden = true;
            self.detailDescription.hidden = true;
            self.ipAdress.hidden = true;
        } else {
            self.deviceName.text = [object objectForKey:@"name"];
            self.taizhangCode.text = [object objectForKey:@"taizhangCode"];
            self.deviceType.text = [object objectForKey:@"deviceType"];
            self.detailDescription.text = [object objectForKey:@"description"];
            self.ipAdress.text = [object objectForKey:@"ipaddress"];
        }
    }];
    
  
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
