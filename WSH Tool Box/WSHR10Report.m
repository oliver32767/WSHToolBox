//
//  WSHR10Report.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
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
