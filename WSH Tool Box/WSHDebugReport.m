//
//  WSHDebugReport.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHDebugReport.h"
#import "McTemplateRenderer.h"

@implementation WSHDebugReport

-(BOOL) generateHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err
{
    NSLog(@"Generating report");
    return [super generateHtml:report error:err];
}

@end
