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
    
    float vaporPressure = [[self objectForKey:@"vaporPressure"] floatValue];
    
    float saturationConcentration = (vaporPressure/760) * pow(10,6);
    float confinedSpace = saturationConcentration * 0.1;
    float poor = saturationConcentration * 0.01;
    float good = saturationConcentration * 0.001;
    float capture = saturationConcentration * 0.0001;
    float containment = saturationConcentration * 0.00001;
    
    [self setObject:[NSNumber numberWithFloat:saturationConcentration] forKey:@"saturationConcentration"];
    [self setObject:[NSNumber numberWithFloat:confinedSpace] forKey:@"confinedSpace"];
    [self setObject:[NSNumber numberWithFloat:poor] forKey:@"poor"];
    [self setObject:[NSNumber numberWithFloat:good] forKey:@"good"];
    [self setObject:[NSNumber numberWithFloat:capture] forKey:@"capture"];
    [self setObject:[NSNumber numberWithFloat:containment] forKey:@"containment"];
    
    return YES;
}

-(BOOL) validateData:(NSError *__autoreleasing *)err
{
    return YES;
}

-(BOOL) generateHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err
{
    if (![self calculate:err]) {
        return NO;
    }
    *report = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withResourceFileTemplate:@"R10ReportTemplate.html"];
    return YES;
}

@end
