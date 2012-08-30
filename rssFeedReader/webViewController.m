//
//  WebViewController.m
//  RSSFeedReader
//
//  Created by Stephanie Shupe on 8/28/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong) UIActivityIndicatorView *indicatorView;
@end

@implementation WebViewController
@synthesize webView = _webView;
@synthesize url = _url;
@synthesize indicatorView = _indicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.indicatorView.color = [UIColor darkGrayColor];
    self.indicatorView.center = self.view.center;
    self.indicatorView.hidesWhenStopped = YES;
    [self.indicatorView startAnimating];
    
    [self.view addSubview:self.indicatorView];
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.url]];
    self.webView.delegate = self;


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
       [self.indicatorView stopAnimating]; 
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
