//
//  WSH_Tool_BoxTests.m
//  WSH Tool BoxTests
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSH_Tool_BoxTests.h"
#import "WSHHistorySource.h"
#import "WSHFormData.h"
#import "WSHPreferences.h"
#import "WSHR10Report.h"

@implementation WSH_Tool_BoxTests

- (void)setUp
{
    [super setUp];
    
    [WSHPreferences resetAllPreferences];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testR10Report
{
    WSHFormData* form = [[WSHFormData alloc] init];
    
    [form setObject:@"Abby" forKey:@"name"];
    [form setObject:@"LSB Room 2522" forKey:@"location"];
    [form setObject:[NSDate date] forKey:@"date"];
    
    [form setObject:@"Bleach" forKey:@"chemicalName"];
    [form setObject:[NSNumber numberWithFloat:10.0f] forKey:@"vaporPressure"];
    [form setObject:[NSNumber numberWithFloat:25.0f] forKey:@"exposureLimit"];
    [form setObject:[NSNumber numberWithFloat:50.0f] forKey:@"stel"];
    [form setObject:[NSNumber numberWithFloat:125.0f] forKey:@"ceiling"];

    WSHR10Report* report = [[WSHR10Report alloc] initWithFormData:form];
    [report calculate:nil];
    
    float actual = round([[[report formData] objectForKey:@"saturationConcentration"] floatValue]);

    NSString* assertion = [NSString stringWithFormat:@"Calculation is wrong, expected 13158.0 but got %f", actual];
    NSAssert((actual == 13158.0f), assertion);

}


- (void)testFormHistory
{

    NSString* archiveKey = @"testHistorySource";
    
    [WSHPreferences removeFormDataArchiveForKey:archiveKey];
    
    WSHHistorySource* hist = [[WSHHistorySource alloc] initWithArchiveWithKey:archiveKey];
    
    

    
    NSDate* d = [NSDate date];
    NSString* s = @"NSString";
    NSNumber* f = [NSNumber numberWithFloat:327.67f];
    
    WSHFormData* form = [[WSHFormData alloc] init];
    NSAssert((hist.count == 0), @"Count is wrong!");
    
    [form setObject:d forKey:@"date"];
    [form setObject:s forKey:@"string"];
    [form setObject:f forKey:@"float"];
    
    [hist addForm:form];
    
    [hist saveToArchiveForKey:archiveKey];
    hist = [[WSHHistorySource alloc] initWithArchiveWithKey:archiveKey];

    form = [hist formAtIndex:0];
    
    NSAssert(([[form objectForKey:@"date"] isEqualToDate:d]), @"Dates don't match!");
    NSAssert(([[form objectForKey:@"string"] isEqualToString:s]), @"Strings don't match");
    NSAssert(([[form objectForKey:@"float"] floatValue] == [f floatValue]), @"Floats don't match!");
    
    WSHFormData* form2 = [[WSHFormData alloc] init];
    [form2 setObject:d forKey:@"date"];
    [form2 setObject:s forKey:@"string"];
    [form2 setObject:f forKey:@"float"];
    [hist addForm:form2];
    
    [hist saveToArchive];
    hist = [[WSHHistorySource alloc] initWithArchiveWithKey:archiveKey];
    
    form = [hist formAtIndex:1];
    
    NSAssert(([[form objectForKey:@"date"] isEqualToDate:d]), @"Dates don't match!");
    NSAssert(([[form objectForKey:@"string"] isEqualToString:s]), @"Strings don't match");
    NSAssert(([[form objectForKey:@"float"] floatValue] == [f floatValue]), @"Floats don't match!");
    
    NSAssert((hist.count == 2), @"Count is wrong!");
    
    [hist removeAllForms];
    
    NSAssert((hist.count == 0), @"Count is wrong!");
    

}

@end
