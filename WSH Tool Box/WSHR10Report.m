//
//  WSHR10Report.m
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


#import "WSHR10Report.h"

@implementation WSHR10Report

-(BOOL) calculate:(NSError**)err
{
    if (![self validateData:err]) {
        // the data isn't valid
        return NO;
    }
    
    float vaporPressure = [[self.formData objectForKey:@"vaporPressure"] floatValue];
    
    float saturationConcentration = (vaporPressure/760) * pow(10,6);
    float confinedSpace = saturationConcentration * 0.1;
    float poor = saturationConcentration * 0.01;
    float good = saturationConcentration * 0.001;
    float capture = saturationConcentration * 0.0001;
    float containment = saturationConcentration * 0.00001;
    
    [self.formData setObject:[NSNumber numberWithFloat:saturationConcentration] forKey:@"saturationConcentration"];
    [self.formData setObject:[NSNumber numberWithFloat:confinedSpace] forKey:@"confinedSpace"];
    [self.formData setObject:[NSNumber numberWithFloat:poor] forKey:@"poor"];
    [self.formData setObject:[NSNumber numberWithFloat:good] forKey:@"good"];
    [self.formData setObject:[NSNumber numberWithFloat:capture] forKey:@"capture"];
    [self.formData setObject:[NSNumber numberWithFloat:containment] forKey:@"containment"];
    
    return YES;
}

-(BOOL) validateData:(NSError *__autoreleasing *)err
{
    return YES;
}

-(BOOL) generateWebViewHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err
{
    if (![self calculate:err]) {
        return NO;
    }
    NSLog(@"reportStyle == 0 %s", ([[self.formData objectForKey:@"reportStyle"] integerValue] == 0) ? "true" : "false");
    if ([[self.formData objectForKey:@"reportStyle"] integerValue] == 0) {
        // standard
        NSLog(@"STANDARD REPORT");
        *report = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withResourceFileTemplate:@"R10ReportTemplate.html"];
    } else {
        // compact
        NSLog(@"COMPACT REPORT");
        *report = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withResourceFileTemplate:@"R10ReportTemplateCompact.html"];
    }

    return YES;
}

-(BOOL) generateEmailHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err
{
    if (![self calculate:err]) {
        return NO;
    }

    if ([self.formData objectForKey:@"reportStyle"] == 0) {
        // standard
        *report = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withResourceFileTemplate:@"R10EmailReportTemplate.html"];
    } else {
        // compact
        *report = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withResourceFileTemplate:@"R10EmailReportTemplateCompact.html"];
    }
    return YES;
}

@end
