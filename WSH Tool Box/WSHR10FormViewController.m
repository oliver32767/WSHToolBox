//
//  WSHR10ViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
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
    
    QEntryElement* name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[WSHPreferences defaultUserName] Placeholder:nil];
    [name setKey:@"name"];
    QEntryElement* location = [[QEntryElement alloc] initWithTitle:@"Location" Value:nil];
    [location setKey:@"location"];
    QDateTimeInlineElement* date = [[QDateTimeInlineElement alloc] initWithTitle:@"Date & Time" date:[NSDate date]];
    [date setKey:@"date"];
    
    [generalInfo addElement:name];
    [generalInfo addElement:location];
    [generalInfo addElement:date];
    
    [root addSection:generalInfo];
    
    QSection *chemicalInfo = [[QSection alloc] initWithTitle:@"Chemical Information"];
    
    QEntryElement* chemicalName = [[QEntryElement alloc] initWithTitle:@"Chemical Name" Value:nil];
    [chemicalName setKey:@"chemicalName"];
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
    WSHR10Report* report = [[WSHR10Report alloc] initWithRootElement:self.root];
    [WSHPreferences setDefaultUserName:[report objectForKey:@"name"]];
    [report setTitle:@"Rule of Ten"];
//    [report setSubtitle: [report.dateFormatter stringFromDate:(NSDate*)[report objectForKey:@"date"]]];
    [self showHtmlReport:report];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
