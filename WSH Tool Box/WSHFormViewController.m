//
//  WSHFormViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
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


#import "WSHFormViewController.h"
#import "WSHReport.h"
#import "WSHHistoryViewController.h"
#import "WSHHtmlReportViewController.h"
#import "QRootElement+AllKeys.h"
#import "WSHPreferences.h"

@interface WSHFormViewController ()

@end

@implementation WSHFormViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.maintainHistory = [WSHPreferences shouldSaveFormDataHistory];
        return [super initWithRoot:[self createRootElement]];
    }
    return self;
}

-(id)initWithFormData:(WSHFormData*)formData
{
    self = [self init];
    if (self) {
        
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

-(NSDictionary*) formData;
{
    NSMutableDictionary* rv = [[NSMutableDictionary alloc] init];
    NSEnumerator* k = [[self.root allElementKeys] objectEnumerator];

    NSString* key = nil;
    id obj;
    QEntryElement* element = nil;

    while (key = [k nextObject]) {
        element = (QEntryElement*)[self.root elementWithKey:key];
        if ([element isKindOfClass:[QDecimalElement class]]) {
            float f = [(QDecimalElement*) element floatValue];
            obj = [NSNumber numberWithFloat:f];
            
        } else if ([element isKindOfClass:[QDateTimeInlineElement class]]) {
            obj = [(QDateTimeInlineElement*) element dateValue];
            
        } else if ([element isKindOfClass: [QEntryElement class]] ||
                   [element isKindOfClass: [QAutoEntryElement class]]) {
            obj = [element textValue];
            
        } else {
            obj = [element value];
        }
        if (obj) {
            [rv setObject:obj forKey:key];
        }
    }
    return rv;
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
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Viewed history: %@", self.title]];
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
