//
//  WSHHistorySource.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
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
