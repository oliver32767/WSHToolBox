//
//  WSHReportFormViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHFormViewController.h"
#import "WSHReport.h"
#import "WSHHistoryViewController.h"
#import "WSHHtmlReportViewController.h"
#import "QRootElement+AllKeys.h"

@interface WSHFormViewController ()

@end

@implementation WSHFormViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.maintainHistory = NO;
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Form initialized"]];
        return [super initWithRoot:[self createRootElement]];
    }
    return self;
}

- (QRootElement*)createRootElement
{
    return [[QRootElement alloc] init];
}

- (void)viewDidLoad
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    if (self.maintainHistory) {
        UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(onHistory)];
        self.navigationItem.rightBarButtonItem = historyButton;
    }
}

-(void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView
{
    [super setQuickDialogTableView:quickDialogTableView];
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor rootViewBackground];
}

- (void) addReportToHistory:(WSHReport*)report
{
    if (self.maintainHistory) {
        NSLog(@"Saving %@ to history", report.description);
    }
}

-(void) showHtmlReport:(WSHReport*)report
{
    WSHHtmlReportViewController* reportViewController = [[WSHHtmlReportViewController alloc] initWithNibName:@"WSHHtmlReportViewController" bundle:nil];
    reportViewController.report = report;
    [self.navigationController pushViewController:reportViewController animated:YES];
}

- (void) onHistory
{
    if (self.maintainHistory) {
        WSHHistoryViewController* historyViewController = [[WSHHistoryViewController alloc] init];
        [self.navigationController pushViewController:historyViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
