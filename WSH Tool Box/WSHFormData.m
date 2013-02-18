//
//  WSHFormData.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/17/13.
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

#import "WSHFormData.h"

#define TITLE_KEY @"_title"
#define SUBTITLE_KEY @"_subtitle"

#define CODER_KEYS @"coder-keys-618def6c21268a7570d772b2772b0e35" // this is the MD5 of the 2013.02.01 ArchLinux install iso :)
#define VERSION_KEY @"version-618def6c21268a7570d772b2772b0e35"
#define TIMESTAMP_KEY @"timestamp-618def6c21268a7570d772b2772b0e35"

#define VERSION 1

@interface WSHFormData ()

@property NSMutableDictionary* data;

@end

@implementation WSHFormData

-(id)init
{
    self = [super init];
    if (self) {
        _version = VERSION;
        _timestamp = [NSDate date];
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        NSArray* coderKeys = [aDecoder decodeObjectForKey:CODER_KEYS];
        for (NSString *key in coderKeys)
        {
            id obj = [aDecoder decodeObjectForKey:key];
            [_data setObject:obj forKey:key];
        }
        _version = [aDecoder decodeIntForKey:VERSION_KEY];
        _timestamp = [aDecoder decodeObjectForKey:TIMESTAMP_KEY];
        if (_version < VERSION) {
            self = [self upgradeToNewVersion:VERSION];
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_data.allKeys forKey:CODER_KEYS];
    for (NSString *key in [_data allKeys])
    {
        id obj = [_data objectForKey:key];
        [aCoder encodeObject:obj forKey:key];
    }
    [aCoder encodeInt:_version forKey:VERSION_KEY];
    [aCoder encodeObject:_timestamp forKey:TIMESTAMP_KEY];
}
-(WSHFormData*)upgradeToNewVersion:(int)v
{
    NSLog(@"This feature is not yet implemented.");
    return nil;
}

- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    if (!anObject) {
        [_data setObject:@"" forKey:aKey];
        NSLog(@"Not An Object:%@ forKey:%@", anObject, aKey);
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
    return [self.data objectForKey:aKey];
}
- (NSArray*) allKeys
{
    return self.data.allKeys;
}

- (NSString*) title
{
    return [self objectForKey:TITLE_KEY];
}
-(void) setTitle:(NSString*)title
{
    [self setObject:[title copy] forKey:TITLE_KEY];
}
-(NSString*)subtitle
{
    return [self objectForKey:SUBTITLE_KEY];
}
-(void)setSubtitle:(NSString*)subtitle
{
    [self setObject:[subtitle copy] forKey:SUBTITLE_KEY];
}

-(NSString*) description
{
    NSString* aTitle = (self.title) ? self.title : @"Untitled Report";
    NSString* aSubtitle = (self.subtitle) ? [NSString stringWithFormat:@" - %@", self.subtitle] : @"";
    return [NSString stringWithFormat:@"%@%@", aTitle, aSubtitle];
}

@end
