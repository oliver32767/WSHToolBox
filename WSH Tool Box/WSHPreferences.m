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

#define UNIQUE_KEY @"%e60aa12974616d86cca6a565a794b6ea" // this is the MD5 for Linux Mint Debian Edition 201204 Xfce 64-bit :)

@implementation WSHPreferences

//+(void) initialize
//{
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:UNIQUE_KEY]) {
//        [self resetAllPreferences];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UNIQUE_KEY];
//    }
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
//}

+(void)defaultsChanged
{
    NSLog(@"NSUserDefaultsDidChangeNotification");
}

+(void) resetAllPreferences
{
    UILog(@"Resetting preferences!");
//    NSLog(@"Resetting preferences!");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self setShouldSaveFieldValueHistory:YES];
    [self setShouldSaveFormDataHistory:YES];
}

+(BOOL) shouldSaveFormDataHistory
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldSaveFormDataHistory"];
}
+(void) setShouldSaveFormDataHistory:(BOOL)value{
    if (!value) {
        [WSHPreferences removeAllArchives];
    }
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"shouldSaveFormDataHistory"];
}

+(BOOL) shouldSaveFieldValueHistory
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldSaveFieldValueHistory"];
}
+(void) setShouldSaveFieldValueHistory:(BOOL)value
{
    if (!value) {
        [WSHPreferences removeAllAutocompleteValues];
        [WSHPreferences removeAllDefaultFieldValues];
    }
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"shouldSaveFieldValueHistory"];
}

#pragma mark field values

+(NSString*) defaultFieldValueWithKey:(id)key
{
    NSDictionary* values = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultFieldValues"];
    return [values objectForKey:key];
}
+(void) setDefaultFieldValue:(id)value forKey:(id<NSCopying>)key
{
    if (![self shouldSaveFieldValueHistory]) return;
    
    NSMutableDictionary* values =  [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultFieldValues"]];
    if (!values) {
        values = [[NSMutableDictionary alloc] init];
    }
    [values setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:values forKey:@"defaultFieldValues"];
}
+(void) removeDefaultFieldValueForKey:(id)key
{
    NSMutableDictionary* values =  [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultFieldValues"]];
    [values removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:values forKey:@"defaultFieldValues"];
}
+(NSArray*) allDefaultFieldValueKeys
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultFieldValues"] allKeys];
}
+(void) removeAllDefaultFieldValues
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultFieldValues"];
}

#pragma mark autocomplete

+(NSArray*) autocompleteValuesWithKey:(id<NSCopying>)key
{
    NSDictionary* values = [[NSUserDefaults standardUserDefaults] objectForKey:@"autocompleteValues"];
    return [values objectForKey:key];
}
+(void) addAutocompleteValue:(NSString*)value forValuesWithKey:(id<NSCopying>)key
{
    if (![self shouldSaveFieldValueHistory]) return;
    
    NSMutableArray* values = [NSMutableArray arrayWithArray:[self autocompleteValuesWithKey:key]];
    if (!values) {
        values = [[NSMutableArray alloc] init];
    }
    [values addObject:value];
    [self setAutoCompleteValues:values forKey:key];
}
+(void) setAutoCompleteValues:(NSArray*)values forKey:(id<NSCopying>)key
{
    if (![self shouldSaveFieldValueHistory]) return;
    
    NSMutableDictionary* autocompleteValues =  [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"autocompleteValues"]];
    if (!autocompleteValues) {
        autocompleteValues = [[NSMutableDictionary alloc] init];
    }
    [autocompleteValues setObject:values forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:autocompleteValues forKey:@"autocompleteValues"];
    
}
+(void) removeAutocompleteValuesWithKey:(id)key
{
    NSMutableDictionary* autocompleteValues = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"autocompleteValues"]];
    [autocompleteValues removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:autocompleteValues forKey:@"autocompleteValues"];
}
+(void) removeAllAutocompleteValues
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autocompleteValues"];
}
+(NSArray*) allAutocompleteValuesKeys
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"autocompleteValues"] allKeys];
}

#pragma mark form data archive

+(NSData*) formDataArchiveWithKey:(id)key
{
    NSMutableDictionary* archives = [[NSUserDefaults standardUserDefaults] objectForKey:@"archives"];
    return [archives objectForKey:key];
}
+(void) setFormDataArchive:(NSData *)archive forKey:(id)key
{
    if (![self shouldSaveFormDataHistory]) return;
    
    NSMutableDictionary* archives = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"archives"]];
    if (!archives) {
        archives = [[NSMutableDictionary alloc] init];
    }
    [archives setObject:archive forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:archives forKey:@"archives"];
}
+(void) removeFormDataArchiveForKey:(id)key
{
    NSMutableDictionary* archives = [[NSUserDefaults standardUserDefaults] objectForKey:@"archives"];
    [archives removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:archives forKey:@"archives"];
}
+(void) removeAllArchives
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"archives"];
}
+(NSArray*) allFormDataArchiveKeys
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"archives"] allKeys];
}

@end
