//
//  WSHPreferences.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/16/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHPreferences.h"

@implementation WSHPreferences

+(NSString*) defaultUserName
{
    NSString* rv = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultUsername"];
    return rv;
}

+(void) setDefaultUserName:(NSString *)defaultUserName
{
    [[NSUserDefaults standardUserDefaults] setObject:defaultUserName forKey:@"defaultUsername"];
}

@end
