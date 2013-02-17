//
//  WSHDebugFormViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/15/13.
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


#import "WSHDebugFormViewController.h"
#import "WSHDebugReport.h"
#import "WSHHtmlReportViewController.h"
#import "WSHPreferences.h"

@interface WSHDebugFormViewController ()

@end

@implementation WSHDebugFormViewController

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
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QRootElement*)createRootElement {
    QRootElement* root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"Rule of Ten";
    
    QEntryElement* name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[WSHPreferences defaultFieldValueWithKey:@"name"] Placeholder:nil];
    [name setKey:@"name"];

    QSection* first = [[QSection alloc] initWithTitle:@"Inputs"];
    QAutoEntryElement* autocomplete = [[QAutoEntryElement alloc] initWithTitle:@"Autocomplete" Value:nil Placeholder:@"start typing for suggestions"];
    [autocomplete setAutoCompleteValues:[WSHPreferences autocompleteValuesWithKey:@"chemicalName"]];
    [autocomplete setKey:@"autocomplete"];

    QDateTimeInlineElement* date = [[QDateTimeInlineElement alloc] initWithTitle:@"Date & Time" date:[NSDate date]];
    [date setKey:@"date"];
    
    QDecimalElement* vaporPressure = [[QDecimalElement alloc] initWithTitle:@"Vapor Pressure" value:0];
    [vaporPressure setKey:@"vaporPressure"];
    [vaporPressure setFractionDigits:1];
    
    [first addElement:name];
    [first addElement:autocomplete];
    [first addElement:date];
    [first addElement:vaporPressure];
    [root addSection:first];
    
    
    
    QSection* actions = [[QSection alloc] init];
    QButtonElement* calculate = [[QButtonElement alloc] initWithTitle:@"Calculate"];
    calculate.controllerAction = @"onCalculate";
    [actions addElement:calculate];
    
    [root addSection:actions];
    return root;
}

- (void) onCalculate
{
    WSHDebugReport* report = [[WSHDebugReport alloc] initWithFormData:[self formData]];
    [self showHtmlReport:report];
//    WSHHtmlReportViewController* reportViewController = [[WSHHtmlReportViewController alloc] initWithNibName:@"WSHHtmlReportViewController" bundle:nil];
//    reportViewController.report = report;
//    [self.navigationController pushViewController:reportViewController animated:YES];
}

@end
