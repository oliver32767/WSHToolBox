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

@implementation WSHPreferences

+(void) resetAllPreferences
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"defaultUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"chemicalNameAutocompleteValues"];
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



@end
