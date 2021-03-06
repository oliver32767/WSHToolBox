//
//  WSHReport.m
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


#import "WSHReport.h"
#import "QRootElement+AllKeys.h"

#define TITLE_KEY @"_title"
#define SUBTITLE_KEY @"_subtitle"
#define TIMESTAMP_KEY @"_timestamp"

#define DEFAULT_DATE_TEMPLATE @"EdMMMyyyyhmma"
#define DEFAULT_FLOAT_FORMAT @"%g"

@interface WSHReport ()

@end

@implementation WSHReport

- (id) init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:
         [NSDateFormatter dateFormatFromTemplate:DEFAULT_DATE_TEMPLATE options:0
                                          locale:[NSLocale currentLocale]]];
        self.floatFormat = DEFAULT_FLOAT_FORMAT;
        _formData = [[WSHFormData alloc] init];
    }
    return self;
}

- (id)initWithFormData:(WSHFormData *)data
{
    self = [self init];
    if (self) {
        _formData = data;
        NSLog(@"%@ - %@", data.title, data.subtitle);
    }
    return self;
}

-(NSString*)title
{
    return [self.formData title];
}
-(void)setTitle:(NSString *)title
{
    [self.formData setTitle:title];
}

-(NSString*)subtitle
{
    return [self.formData subtitle];
}
-(void)setSubtitle:(NSString *)subtitle
{
    [self.formData setSubtitle:subtitle];
}

-(BOOL) validateData:(NSError *__autoreleasing *)err
{
    return YES;
}
-(BOOL) calculate:(NSError**)err
{
    return YES;
}

-(BOOL) generateWebViewHtml:(NSString *__autoreleasing *)html error:(NSError *__autoreleasing *)err
{
    NSString* template = @"<html><head><title>{{_title||Untitled Report}}</title></head><body><p style=\"text-align:center;\">{{_title||Default Report}}<br/>{{_subtitle||}}</p><table style=\"width:100%;\"><tbody><tr><td style=\"width:50%; text-align:right;\">key</td><td style=\"width:50%;\">value</td></tr>";
    
    NSEnumerator* k = [self.formData.allKeys objectEnumerator];
    NSString* key = nil;
    while (key = [k nextObject]) {
        template = [NSString stringWithFormat: @"%@<tr><td style=\"text-align:right;\">%@</td><td>{{%@}}</td></tr>",
                    template,
                    key, key];
    }
    template = [NSString stringWithFormat:@"%@</tbody></table></body></html>", template];
    
    *html = [McTemplateRenderer render:self.dictionaryWithStringsForObjects withTemplate:template];
    return YES;
}
-(BOOL) generateEmailHtml:(NSString *__autoreleasing *)report error:(NSError *__autoreleasing *)err
{
    return [self generateWebViewHtml:report error:err];
}

- (NSDictionary*) dictionaryWithStringsForObjects
{
    NSMutableDictionary* rv = [[NSMutableDictionary alloc] init];
    for (id key in [self.formData allKeys]) {
        [rv setObject:[self stringForObject:[self.formData objectForKey:key]
                                    withKey:key]
               forKey:key];
    }
    return [[NSDictionary alloc] initWithDictionary:rv];
}

-(NSString*) stringForObject:(id)obj withKey:(id)key
{
    if ([obj isKindOfClass:[NSDate class]]) {
        return [self.dateFormatter stringFromDate:obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        float f = [obj floatValue];
        return [NSString stringWithFormat:self.floatFormat, f];
    }
    return [obj description];
}


-(NSString*) description
{
    return _formData.description;
}

@end
