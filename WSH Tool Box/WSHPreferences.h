//
//  WSHPreferences.h
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


#import <Foundation/Foundation.h>

@interface WSHPreferences : NSObject

// this should only ever be used in debug mode
+(void) resetAllPreferences;

+(BOOL) shouldSaveFormDataHistory;
+(void) setShouldSaveFormDataHistory:(BOOL)value;

+(BOOL) shouldSaveFieldValueHistory;
+(void) setShouldSaveFieldValueHistory:(BOOL)value;

+(NSString*) defaultFieldValueWithKey:(id)key;
+(void) setDefaultFieldValue:(id)value forKey:(id<NSCopying>)key;
+(void) removeDefaultFieldValueForKey:(id)key;
+(NSArray*) allDefaultFieldValueKeys;

+(NSArray*) autocompleteValuesWithKey:(id)key;
+(void) addAutocompleteValue:(NSString*)value forValuesWithKey:(id<NSCopying>)key;
+(void) setAutoCompleteValues:(NSArray*)values forKey:(id<NSCopying>)key;
+(void) removeAutocompleteValuesWithKey:(id)key;
+(NSArray*) allAutocompleteValuesKeys;

+(NSData*) formDataArchiveWithKey:(id)key;
+(void) setFormDataArchive:(NSData*)archive forKey:(id<NSCopying>)key;
+(void) removeFormDataArchiveForKey:(id)key;
+(NSArray*) allFormDataArchiveKeys;

@end
