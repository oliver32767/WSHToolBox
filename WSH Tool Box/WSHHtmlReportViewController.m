//
//  WSHHtmlReportViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHHtmlReportViewController.h"

#define WEBVIEW_TAG 1

@interface WSHHtmlReportViewController ()

@property UIWebView* webView;

@end

@implementation WSHHtmlReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.report.title) {
        self.title = self.report.title;
    } else {
        self.title = @"Report";
    }
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(onSend)];
    [sendButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    self.webView = (UIWebView*) [self.view viewWithTag:WEBVIEW_TAG];
    self.webView.delegate = self;
    NSString* aReport = [[NSString alloc] init];

    [self.report generateHtml:&aReport error:nil];
    [self.webView loadHTMLString:aReport baseURL:nil];
    
    [self applyMotif];

}

-(void)applyMotif
{
    [self.webView setBackgroundColor:[UIColor reportViewBackground]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Generated report '%@'", [self.report description]]];
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void) onSend
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject: [self.report description]];
        [controller setMessageBody:[self stringWithContentsOfWebView] isHTML:YES];
        if (controller) [self presentModalViewController:controller animated:YES];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts"
                                                          message:@"Please set up a Mail account in order to send email."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Email result 'denied' for report '%@'", [self.report description]]];
    }
    
}

- (NSString*) stringWithContentsOfWebView
{
    return [self.webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    NSString* resultString = nil;
    if (result == MFMailComposeResultCancelled) {
        resultString = @"cancelled";
    } else if (result == MFMailComposeResultFailed) {
        resultString = @"failed";
    } else if (result == MFMailComposeResultSaved) {
        resultString = @"saved";
    } else if (result == MFMailComposeResultSent) {
        resultString = @"sent";
    } else {
        resultString = @"unknown";
    }

     [TestFlight passCheckpoint:[NSString stringWithFormat:@"Email result '%@' for report '%@'", resultString, [self.report description]]];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
