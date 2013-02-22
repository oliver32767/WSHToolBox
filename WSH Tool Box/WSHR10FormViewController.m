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
    QDateTimeInlineElement* date = [[QDateTimeInlineElement alloc] initWithTitle:@"Spill Date/Time" date:[NSDate date]];
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
    
    QDecimalElement* vaporPressure = [[QDecimalElement alloc] initWithTitle:@"Vapor Pressure (mm)" value:0];
    [vaporPressure setKey:@"vaporPressure"];
//    [vaporPressure setFractionDigits:1];
    QDecimalElement* exposureLimit = [[QDecimalElement alloc] initWithTitle:@"Exposure Limit (ppm)" value:0];
    [exposureLimit setKey:@"exposureLimit"];
    [exposureLimit setFractionDigits:3];
    QDecimalElement* stel = [[QDecimalElement alloc] initWithTitle:@"STEL (ppm)" value:0];
    [stel setKey:@"stel"];
    [stel setFractionDigits:3];
    QDecimalElement* ceiling = [[QDecimalElement alloc] initWithTitle:@"Ceiling (ppm)" value:0];
    [ceiling setKey:@"ceiling"];
    [ceiling setFractionDigits:3];
    
    [chemicalInfo addElement:chemicalName];
    [chemicalInfo addElement:vaporPressure];
    [chemicalInfo addElement:exposureLimit];
    [chemicalInfo addElement:stel];
    [chemicalInfo addElement:ceiling];
    
    [root addSection:chemicalInfo];

    
    QSection* links = [[QSection alloc] initWithTitle:@"Links"];
    QButtonElement* wiser = [[QButtonElement alloc] initWithTitle:@"WebWISER"]; //Vapor Pressure
    wiser.controllerAction = @"onWiser";
    QButtonElement* tlvs = [[QButtonElement alloc] initWithTitle:@"2005 TLVs (pdf)"]; //Exposure Limits
    tlvs.controllerAction = @"onTlvs";
    
    [links addElement:wiser];
    [links addElement:tlvs];
    [root addSection:links];
    
    QSection* actions = [[QSection alloc] init];
    QButtonElement* calculate = [[QButtonElement alloc] initWithTitle:@"Calculate"];

    calculate.controllerAction = @"onCalculate";

    [actions addElement:calculate];
    
    [root addSection:actions];
    
    return root;
}

-(void)onWiser
{
    NSURL *url = [NSURL URLWithString:@"http://webwiser.nlm.nih.gov/knownSubstanceSearch.do"];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)onTlvs
{
    NSURL *url = [NSURL URLWithString:@"http://www.stps.gob.mx/DGIFT_STPS/PDF/2005TLVsBEIsofACGIHHandbook.pdf"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) onCalculate
{
    WSHFormData* form = [self formData];
    
    form.title = @"Rule of Ten";
    
    NSString* subtitle = @"";
    if ([form objectForKey:@"location"]) {
        subtitle = [NSString stringWithFormat: @"%@", [form objectForKey:@"location"]];
    } else {
        subtitle = @"Unknown Location";
    }
    if ([form objectForKey:@"chemicalName"] && [(NSString*) [form objectForKey:@"chemicalName"] length] > 0) {
        subtitle = [NSString stringWithFormat: @"%@ - %@", subtitle, [form objectForKey:@"chemicalName"]];
    }
    
    form.subtitle = subtitle;
    
    if ([form objectForKey:@"name"]) {
        [WSHPreferences setDefaultFieldValue:[form objectForKey:@"name"] forKey:@"name"];
    }
    
    if ([form objectForKey:@"chemicalName"]) {
        [WSHPreferences addAutocompleteValue:[form objectForKey:@"chemicalName"] forValuesWithKey:@"chemicalName"];
    }
    WSHR10Report* report = [[WSHR10Report alloc] initWithFormData:[self formData]];

    UILog(report.description);
    if ([self maintainHistory]) {
        [self addFormToHistory:form];
    }
    [self showHtmlReport:report];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
