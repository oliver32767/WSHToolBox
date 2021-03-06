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

#import <objc/runtime.h>

#import "WSHFormViewController.h"
#import "WSHReport.h"
#import "WSHHistoryViewController.h"
#import "WSHHtmlReportViewController.h"
#import "QRootElement+AllKeys.h"
#import "WSHPreferences.h"
#import "WSHHistorySource.h"

@interface WSHFormViewController ()

@property WSHHistorySource* historySource;

@end

@implementation WSHFormViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.maintainHistory = [WSHPreferences shouldSaveFormDataHistory];
        if (_maintainHistory) {
            NSString* className = [NSString stringWithUTF8String: class_getName([self class])];
            NSLog(@"Loading history for: %@", className);
            _historySource = [[WSHHistorySource alloc] initWithArchiveWithKey:className];
        }
        return [super initWithRoot:[self createRootElement]];
    }
    return self;
}

//-(id)initWithFormData:(WSHFormData*)formData
//{
//    self = [self init];
//    if (self) {
//        
//    }
//    return self;
//}

- (QRootElement*)createRootElement
{
    return [[QRootElement alloc] init];
}

- (QRootElement*)createRootElementWithFormData:(WSHFormData*)formData
{
    QRootElement* root = [self createRootElement];
    QEntryElement* element;
    for (id key in [formData allKeys]) {
        element = (QEntryElement*)[root elementWithKey:key];
        if ([element isKindOfClass:[QDecimalElement class]]) {
            [(QDecimalElement*) element setFloatValue:[[formData objectForKey:key] floatValue]];
        } else if ([element isKindOfClass:[QDateTimeInlineElement class]]) {
            
            [(QDateTimeInlineElement*) element setDateValue:[formData objectForKey:key]];
            
        } else if ([element isKindOfClass: [QRadioElement class]]) {
            [(QRadioElement*) element setSelectedValue:[formData objectForKey:key]];
            
        } else if ([element isKindOfClass: [QEntryElement class]] ||
                   [element isKindOfClass: [QAutoEntryElement class]]) {
            // this clause should probalby stay last, as it's a common superclass
            [element setTextValue:[formData objectForKey:key]];

        } else {
            [element setValue:[formData objectForKey:key]];
        }
    }
    [self.quickDialogTableView reloadData];
    return root;
}


- (void)viewDidLoad
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    NSMutableArray* rightBarButtons = [[NSMutableArray alloc] init];
    
    if (self.maintainHistory) {
        UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_24.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onHistory)];
//        UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(onHistory)];
        [rightBarButtons addObject:historyButton];
//        self.navigationItem.rightBarButtonItem = historyButton;
    }
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash_24.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onClear)];
//    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(onClear)];
    [rightBarButtons addObject:clearButton];
    self.navigationItem.rightBarButtonItems = rightBarButtons;
}

-(void) setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView
{
    [super setQuickDialogTableView:quickDialogTableView];
    
    if ([self respondsToSelector:@selector(cell:willAppearForElement:atIndexPath:)]) {
        [self.quickDialogTableView setStyleProvider:(NSObject <QuickDialogStyleProvider>*)self];
    }
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor rootViewBackground];
}

-(void)didSelectHistoryItem:(WSHFormData*)formData
{
    NSLog(@"Showing history item: %@", formData.timestamp);
    [self setRoot:[self createRootElementWithFormData:formData]];
}


-(WSHFormData*) formData;
{
    WSHFormData* rv = [[WSHFormData alloc] init];
    [rv setTitle:self.title];
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

            
        } else if ([element isKindOfClass:[QRadioElement class]]) {
            obj = [NSNumber numberWithInt:[(QRadioElement*) element selected]];
            
        } else if ([element isKindOfClass: [QEntryElement class]] ||
                   [element isKindOfClass: [QAutoEntryElement class]]) {
            // this clause should probably come last because QEntryElement is a pretty common super class among
            // Dialog elements
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

- (void) addFormToHistory:(WSHFormData*)form
{
    if (self.maintainHistory) {
        NSLog(@"Saving %@ to history", form.description);
        [_historySource addForm:form];
//        [_historySource saveToArchiveForKey:[NSString stringWithUTF8String: class_getName([self class])]];
    }
}

-(void) showHtmlReport:(WSHReport*)report
{
    WSHHtmlReportViewController* reportViewController = [[WSHHtmlReportViewController alloc] initWithNibName:@"WSHHtmlReportViewController" bundle:nil];
    reportViewController.report = report;
    [self.navigationController pushViewController:reportViewController animated:YES];
}


-(void) onClear {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Form"
                                                    message:@"Are you sure you want to clear this form?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Clear", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self setRoot: [self createRootElement]];
    }
}

- (void) onHistory
{
    if (self.maintainHistory) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Viewed history: %@", self.title]];
        WSHHistoryViewController* historyViewController = [[WSHHistoryViewController alloc] initWithHistorySource:_historySource delegate:self];
        [self.navigationController pushViewController:historyViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
