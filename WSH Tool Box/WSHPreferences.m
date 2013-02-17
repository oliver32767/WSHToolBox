//
//  WSHPreferences.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/16/13.
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


#import "WSHPreferences.h"

#define UNIQUE_KEY @"%@-e60aa12974616d86cca6a565a794b6ea" // this is the MD5 for Linux Mint Debian Edition 201204 Xfce 64-bit :)

@implementation WSHPreferences

static WSHPreferences *singleton;
static NSMutableArray* archiveKeys;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        singleton = [[WSHPreferences alloc] init];
        archiveKeys = [[NSUserDefaults standardUserDefaults] objectForKey:[self unique:@"archiveKeys"]];
        if (!archiveKeys) {
            archiveKeys = [[NSMutableArray alloc] init];
        }
        NSLog(@"Initialized archiveKeys:%@", archiveKeys);

    }
}

+(NSString*) unique:(id)key
{
    return [NSString stringWithFormat:UNIQUE_KEY, key];
}

+(void) resetAllPreferences
{
    NSLog(@"Resetting preferences!");
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"defaultUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"chemicalNameAutocompleteValues"];
    [self removeAllArchives];
}

+(NSString*) defaultUserName
{
    NSString* rv = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultUsername"];
    return rv;
}

+(void) setDefaultUserName:(NSString *)defaultUserName
{
    [[NSUserDefaults standardUserDefaults] setObject:defaultUserName forKey:@"defaultUsername"];
}

+(NSArray*) chemicalNameAutocompleteValues
{
    NSArray* rv = [[NSUserDefaults standardUserDefaults] arrayForKey:@"chemicalNameAutocompleteValues"];
    
    return rv;
}
+(void) removeAllChemicalNameAutocompleteValues
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"chemicalNameAutocompleteValues"];
}
+(void) addChemicalNameAutocompleteValue: (NSString*)value
{
    if (![[[NSUserDefaults standardUserDefaults] arrayForKey:@"chemicalNameAutocompleteValues"] containsObject:value]) {
        NSMutableArray* arr = [NSMutableArray arrayWithArray:[self chemicalNameAutocompleteValues]];
        [arr addObject:value];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"chemicalNameAutocompleteValues"];
    }
}


+(NSData*) archiveWithKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] dataForKey: [self unique:key]];
    
}
+(void) setArchive:(NSData*)archive forKey:(id)key;
{
    [[NSUserDefaults standardUserDefaults] setObject:archive forKey:[self unique:key]];
    [archiveKeys addObject:[self unique:key]];
    [self saveArchiveKeys];

}
+(void) removeArchiveWithKey:(id)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self unique:key]];
    [archiveKeys removeObject:[self unique:key]];
    [self saveArchiveKeys];
}
+(void) removeAllArchives
{
    for (id key in archiveKeys) {
        [self removeArchiveWithKey:key];
        [archiveKeys removeObject:key];
    }
    [self saveArchiveKeys];
}
+(void) saveArchiveKeys
{
    [[NSUserDefaults standardUserDefaults] setObject:archiveKeys forKey:[self unique:@"archiveKeys"]];
    NSLog(@"archiveKeys:%@", archiveKeys);
}

@end
