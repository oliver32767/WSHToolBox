//
//  WSHHistoryElement.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHReport.h"
#import "QRootElement+AllKeys.h"

#define TITLE_KEY @"_title"
#define SUBTITLE_KEY @"_subtitle"

#define DEFAULT_DATE_TEMPLATE @"EdMMMyyyyhmma"
#define DEFAULT_FLOAT_FORMAT @"%g"

@interface WSHReport ()

@property NSMutableDictionary* data;

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
        self.data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        return [self initWithTitle:title andSubtitle:nil];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    self = [self init];
    if (self) {
        [self setTitle:title];
        [self setSubtitle:subtitle];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{
    self = [self init];
    if (self) {
        self.data = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary];
    }
    return self;
}

-(id) initWithRootElement:(QRootElement *)root
{
    self = [self init];
    if (self) {
        NSEnumerator* k = [[root allElementKeys] objectEnumerator];
        NSString* key = nil;
        QEntryElement* element = nil;
        while (key = [k nextObject]) {
            element = (QEntryElement*)[root elementWithKey:key];
            if ([element isKindOfClass:[QDecimalElement class]]) {
                
                float f = [(QDecimalElement*) element floatValue];
                
                [self setObject:[NSNumber numberWithFloat:f]
                         forKey:key];
                
            } else if ([element isKindOfClass:[QDateTimeInlineElement class]]) {
                NSDate* date = [(QDateTimeInlineElement*) element dateValue];
                [self setObject:[self.dateFormatter stringFromDate:date] forKey:key];
                
            } else if ([element isKindOfClass: [QEntryElement class]]) {
                [self setObject:[element textValue] forKey:key];
                
            } else {
                [self setObject:[element value] forKey:key];
            }
        }
    }
    return self;
}

-(NSString*)title
{
    return [self.data objectForKey:TITLE_KEY];
}
-(void)setTitle:(NSString *)title
{
    [_data setObject:title forKey:TITLE_KEY];
}

-(NSString*)subtitle
{
    return [self.data objectForKey:SUBTITLE_KEY];
}
-(void)setSubtitle:(NSString *)subtitle
{
    [_data setObject:subtitle forKey:SUBTITLE_KEY];
}

-(BOOL) validateData:(NSError *__autoreleasing *)err
{
    return YES;
}

-(BOOL) generateHtml:(NSString *__autoreleasing *)html error:(NSError *__autoreleasing *)err
{
    NSString* template = @"<html><head><title>{{_title||Untitled Report}}</title></head><body><p style=\"text-align:center;\">{{_title||Default Report}}<br/>{{_subtitle||}}</p><table style=\"width:100%;\"><tbody><tr><td style=\"width:50%; text-align:right;\">key</td><td style=\"width:50%;\">value</td></tr>";
    
    NSEnumerator* k = [self.allKeys objectEnumerator];
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

- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    if (!anObject) {
        [_data setObject:@"" forKey:aKey];
    } else {
        [_data setObject:anObject forKey:aKey];
    }

}
- (void)removeObjectForKey:(id)aKey
{
    [_data removeObjectForKey:aKey];
}

- (NSUInteger)count
{
    return _data.count;
}
- (id)objectForKey:(id)aKey
{
    return [_data objectForKey:aKey];
}
- (NSArray*) allKeys
{
    return _data.allKeys;
}

- (NSDictionary*) dictionaryWithStringsForObjects
{
    NSMutableDictionary* rv = [[NSMutableDictionary alloc] init];
    for (id key in [_data allKeys]) {
        [rv setObject:[self stringForObject:[_data objectForKey:key]
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
    NSString* aTitle = (self.title) ? self.title : @"Untitled Report";
    NSString* aSubtitle = (self.subtitle) ? [NSString stringWithFormat:@" - %@", self.subtitle] : @"";
    return [NSString stringWithFormat:@"%@%@", aTitle, aSubtitle];
}

@end
