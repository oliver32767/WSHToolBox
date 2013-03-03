//
//  WSHHistorySource.m
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


#import "WSHHistorySource.h"
#import "WSHPreferences.h"

@interface WSHHistorySource ()

@property NSMutableArray* forms;

@end

@implementation WSHHistorySource

-(id)init
{
    self = [super init];
    if (self) {
        _forms = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id) initWithArchive:(NSData *)archive
{
    self = [self init];
    if (self) {
        _forms = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
        if (!_forms) {
            _forms = [[NSMutableArray alloc] init];    
        }
    }
    return self;
}
-(id)initWithArchiveWithKey:(NSString*)key
{
    _archiveKey = [NSString stringWithString:key];
    return [self initWithArchive:[WSHPreferences formDataArchiveWithKey:key]];
}

-(void)saveToArchive
{
    [self saveToArchiveForKey:_archiveKey];
}
-(void)saveToArchiveForKey:(NSString*)key
{
    _archiveKey = [NSString stringWithString:key];
    NSData* archive = [self archive];
    [WSHPreferences setFormDataArchive:archive forKey:key];
}

-(NSData*)archive
{
    NSData* rv = [NSKeyedArchiver archivedDataWithRootObject:_forms];
    return rv;
}

-(int)count
{
    return _forms.count;
}
-(void)addForm:(WSHFormData*)form
{
    [_forms addObject:form];
    [self saveToArchive];
}
-(WSHFormData*)formAtIndex:(NSUInteger) index
{
    return [_forms objectAtIndex:index];
}
-(void)removeAllForms
{
    [_forms removeAllObjects];
    [self saveToArchive];
}

@end
