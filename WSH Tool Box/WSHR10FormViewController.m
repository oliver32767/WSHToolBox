//
//  WSHR10FormViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
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


#import "WSHR10FormViewController.h"
#import "WSHR10Report.h"
#import "WSHHtmlReportViewController.h"
#import "WSHDebugReport.h"
#import "WSHPreferences.h"

@interface WSHR10FormViewController ()

@end

@implementation WSHR10FormViewController

- (QRootElement*)createRootElement {
    QRootElement* root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"Rule of Ten";
    
    QSection *generalInfo = [[QSection alloc] initWithTitle:@"General Information"];
    
    QEntryElement* name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[WSHPreferences defaultFieldValueWithKey:@"name"] Placeholder:nil];
    [name setKey:@"name"];
    [name setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    QEntryElement* location = [[QEntryElement alloc] initWithTitle:@"Location" Value:nil];
    [location setKey:@"location"];
    QDateTimeInlineElement* date = [[QDateTimeInlineElement alloc] initWithTitle:@"Date & Time" date:[NSDate date]];
    [date setKey:@"date"];
    
    [generalInfo addElement:name];
    [generalInfo addElement:location];
    [generalInfo addElement:date];
    
    [root addSection:generalInfo];
    
    QSection *chemicalInfo = [[QSection alloc] initWithTitle:@"Chemical Information"];
    
    //QEntryElement* chemicalName = [[QEntryElement alloc] initWithTitle:@"Chemical Name" Value:nil];
    QAutoEntryElement* chemicalName = [[QAutoEntryElement alloc] initWithTitle:@"Chemical Name" Value:nil Placeholder:nil];
    [chemicalName setKey:@"chemicalName"];
    [chemicalName setAutoCompleteValues:[WSHPreferences autocompleteValuesWithKey:@"chemicalName"]];

    [chemicalName setAutoCompleteColor:[UIColor autocompleteColor]];
    
    QDecimalElement* vaporPressure = [[QDecimalElement alloc] initWithTitle:@"Vapor Pressure" value:0];
    [vaporPressure setKey:@"vaporPressure"];
    [vaporPressure setFractionDigits:1];
    QDecimalElement* exposureLimit = [[QDecimalElement alloc] initWithTitle:@"Exposure Limit" value:0];
    [exposureLimit setKey:@"exposureLimit"];
    QDecimalElement* stel = [[QDecimalElement alloc] initWithTitle:@"STEL" value:0];
    [stel setKey:@"stel"];
    QDecimalElement* ceiling = [[QDecimalElement alloc] initWithTitle:@"Ceiling" value:0];
    [ceiling setKey:@"ceiling"];
    
    [chemicalInfo addElement:chemicalName];
    [chemicalInfo addElement:vaporPressure];
    [chemicalInfo addElement:exposureLimit];
    [chemicalInfo addElement:stel];
    [chemicalInfo addElement:ceiling];
    
    [root addSection:chemicalInfo];
    
    QSection* actions = [[QSection alloc] init];
    QButtonElement* calculate = [[QButtonElement alloc] initWithTitle:@"Calculate"];
    calculate.controllerAction = @"onCalculate";
    [actions addElement:calculate];
    
    [root addSection:actions];
    
    return root;
}

- (void) onCalculate
{
    WSHR10Report* report = [[WSHR10Report alloc] initWithFormData:[self formData]];
    if ([report.formData objectForKey:@"name"]) {
        [WSHPreferences setDefaultFieldValue:[report.formData objectForKey:@"name"] forKey:@"name"];
    }
    
    if ([report.formData objectForKey:@"chemicalName"]) {
        [WSHPreferences addAutocompleteValue:[report.formData objectForKey:@"chemicalName"] forValuesWithKey:@"chemicalName"];
    }
    
    [report setTitle:@"Rule of Ten"];
    [self showHtmlReport:report];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
