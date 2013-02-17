//
//  WSHHistoryElement.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "McTemplateRenderer.h"
#import "WSHHtmlReporting.h"

@interface WSHReport : NSObject <WSHHtmlReporting>

@property (copy) NSDateFormatter* dateFormatter;
@property NSString* floatFormat;

@property NSString* title;
@property NSString* subtitle;

-(id)initWithTitle:(NSString*)title;
-(id)initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle;
-(id)initWithDictionary:(NSDictionary *)otherDictionary;
-(id)initWithRootElement:(QRootElement*)root;

-(NSDictionary*) dictionaryWithStringsForObjects;
-(NSString*) stringForObject:(id)obj withKey:(id <NSCopying>)key;

- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey;
- (void)removeObjectForKey:(id)aKey;

- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSArray *)allKeys;

- (BOOL)validateData:(NSError**)err;
-(BOOL) generateHtml:(NSString**)html error:(NSError**)err;

@end
