//
//  detailViewController.m
//  SZQRCodeViewController
//
//  Created by iris feng on 2017/3/20.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *testWebView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation detailViewController

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
    
    _textLbl.backgroundColor = [UIColor clearColor];
    _textLbl.hidden = true;
    
    _testWebView.opaque = NO;
    _testWebView.backgroundColor = [UIColor clearColor];
    _testWebView.delegate = self;
    
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    
//    [_indicator startAnimating];
    
    NSURL *url;
    NSLog(@"%@",self.codeOutString);
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

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicator stopAnimating];
}



@end
