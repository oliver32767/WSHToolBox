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

- (void)testHistory
{

    NSString* archiveKey = @"testHistorySource";
    
    [WSHPreferences removeFormDataArchiveForKey:archiveKey];
    
    WSHHistorySource* hist = [[WSHHistorySource alloc] init];
    
    

    
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
