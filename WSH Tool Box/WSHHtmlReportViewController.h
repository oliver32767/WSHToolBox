//
//  WSHHtmlReportViewController.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WSHReport.h"
@interface WSHHtmlReportViewController : UIViewController <MFMailComposeViewControllerDelegate, UIWebViewDelegate>

@property WSHReport* report;

@end
