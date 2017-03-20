//
//  detailViewController.m
//  SZQRCodeViewController
//
//  Created by iris feng on 2017/3/20.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *testWebView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;


@end

@implementation detailViewController

- (IBAction)donePressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _textLbl.hidden = true;
    NSURL *url;
    NSLog(@"传递后的字符串是：%@",self.codeOutString);
    if ([_codeOutString hasPrefix:@"http://"] || [_codeOutString hasPrefix:@"https://"] ) {
        url = [NSURL URLWithString:_codeOutString];
        NSURLRequest *request = [NSURLRequest requestWithURL: url];
        [_testWebView loadRequest:request];
    
    } else {
        _testWebView.hidden = true;
        _textLbl.hidden = false;
        _textLbl.text = _codeOutString;
    }
//        [self.testWebView loadHTMLString:_codeOutString baseURL:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
