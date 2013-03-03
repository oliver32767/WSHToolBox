//
//  WSHInfoViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/22/13.
//  Copyright 2013 Oliver Bartley - http://brtly.net
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
//  file except in compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under
//  the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
//  ANY KIND, either express or implied. See the License for the specific language governing
//  permissions and limitations under the License.
//

#import "WSHInfoViewController.h"

#define RELOAD @"Reload"
#define OPEN_IN_SAFARI @"Open in Safari"


@interface WSHInfoViewController ()

@property UIWebView* webView;
//@property UIActionSheet* actionSheet;
@property UIActionSheet *actionSheet;

@end

@implementation WSHInfoViewController

-(id)init
{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        [_webView setDelegate:self];
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:_webView];
        
    }
    return self;
}

-(id)initWithURLString:(NSString*)URL
{
    self = [self init];
    if (self) {
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
        [_webView loadRequest:request];
        [self setTitle:URL];
        [self showNavigationSpinner];
    }
    return self;
}

-(void)showNavigationSpinner
{
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Set to Left or Right
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
}
-(void) showNavigationInfoButton
{
    UIButton* myInfoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [myInfoButton addTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myInfoButton];
}

-(void)infoButtonClicked
{
    if (_actionSheet) {
        // do nothing
    } else {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:RELOAD, OPEN_IN_SAFARI, nil];
    }
    [_actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // destroy something
        NSLog(@"Destroy");
    } else if ([choice isEqualToString:RELOAD]){
        NSLog(RELOAD);
        [self showNavigationSpinner];
        [_webView reload];
    } else if ([choice isEqualToString:OPEN_IN_SAFARI]) {
        NSLog(OPEN_IN_SAFARI);
        [[UIApplication sharedApplication] openURL:_webView.request.URL];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self showNavigationInfoButton];
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
