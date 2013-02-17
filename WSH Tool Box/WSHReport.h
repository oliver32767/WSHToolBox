//
//  WSHReport.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
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
#import "McTemplateRenderer.h"
#import "WSHHtmlReporting.h"

@interface WSHReport : NSObject <WSHHtmlReporting>

@property (copy) NSDateFormatter* dateFormatter;
@property NSString* floatFormat;

@property NSString* title;
@property NSString* subtitle;
@property NSMutableDictionary* formData;

-(id)initWithTitle:(NSString*)title;
-(id)initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle;
-(id)initWithFormData:(NSDictionary*)data;

-(NSDictionary*) dictionaryWithStringsForObjects;
-(NSString*) stringForObject:(id)obj withKey:(id <NSCopying>)key;
//
//- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey;
//- (void)removeObjectForKey:(id)aKey;
//
//- (NSUInteger)count;
//- (id)objectForKey:(id)aKey;
//- (NSArray *)allKeys;

- (BOOL)validateData:(NSError**)err;
//-(BOOL) generateHtml:(NSString**)html error:(NSError**)err;

@end
