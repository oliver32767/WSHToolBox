//
//  WSHReportFormViewController.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "QuickDialogController.h"
#import "WSHReport.h"

@interface WSHFormViewController : QuickDialogController

-(void) showHtmlReport:(WSHReport*)report;

@property BOOL maintainHistory;

@end
