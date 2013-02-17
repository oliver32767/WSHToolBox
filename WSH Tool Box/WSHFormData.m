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

#define CODER_KEYS @"618def6c21268a7570d772b2772b0e35" // this is the MD5 of the 2013.02.01 ArchLinux install iso :)

@interface WSHFormData ()

@property NSMutableDictionary* data;

@end

@implementation WSHFormData

-(id)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        NSArray* coderKeys = [aDecoder decodeObjectForKey:CODER_KEYS];
        NSLog(@"Decoding");
        for (NSString *key in coderKeys)
        {
            id obj = [aDecoder decodeObjectForKey:key];
            NSLog(@"%@ = %@", key, obj);
            [_data setObject:obj forKey:key];
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Encoding");
    [aCoder encodeObject:_data.allKeys forKey:CODER_KEYS];
    for (NSString *key in [_data allKeys])
    {
        id obj = [_data objectForKey:key];
        NSLog(@"%@ = %@", key, obj);
        [aCoder encodeObject:obj forKey:key];
    }
}

- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    NSLog(@"setObject:%@", anObject);
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
    return [self.data objectForKey:aKey];
}
- (NSArray*) allKeys
{
    return self.data.allKeys;
}

@end
