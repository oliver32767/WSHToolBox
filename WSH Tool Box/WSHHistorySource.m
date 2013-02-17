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

@interface WSHHistorySource ()

@property NSMutableArray* data;

@end

@implementation WSHHistorySource

-(id) initWithContentsOfFile:(NSString*)path
{
    
}
-(BOOL)writeToFile:(NSString *)path
{
    
}

-(void) insertElement:(WSHReport*)element
{
    [_data insertObject:element atIndex:0];
}
-(WSHReport*) elementAtIndex:(NSUInteger)index
{
    return [_data objectAtIndex:index];
}

-(void) removeElementAtIndex:(NSUInteger)index
{
    [_data removeObjectAtIndex:index];
}
-(void) removeAllElements
{
    [_data removeAllObjects];
}

-(NSUInteger) count
{
    return _data.count;
}

@end
