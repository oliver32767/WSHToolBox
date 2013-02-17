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
    
    // Set-up code here.
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
    
    
    WSHFormData* form = [[WSHFormData alloc] init];
    
    NSDate* d = [NSDate date];
    NSString* s = @"NSString";
    NSNumber* f = [NSNumber numberWithFloat:327.67f];
    
    [form setObject:d forKey:@"date"];
    [form setObject:s forKey:@"string"];
    [form setObject:f forKey:@"float"];
    
    [hist addForm:form];

    [WSHPreferences setFormDataArchive:[hist archive] forKey:archiveKey];
    
    hist = [[WSHHistorySource alloc] initWithArchive:[WSHPreferences formDataArchiveWithKey:archiveKey]];
    form = [hist formAtIndex:0];
    
    NSAssert(([[form objectForKey:@"date"] isEqualToDate:d]), @"Dates don't match!");
    NSAssert(([[form objectForKey:@"string"] isEqualToString:s]), @"Strings don't match");
    NSAssert(([[form objectForKey:@"float"] floatValue] == [f floatValue]), @"Floats don't match!");

}

@end
