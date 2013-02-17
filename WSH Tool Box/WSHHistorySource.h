//
//  WSHHistorySource.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSHReport.h"

@interface WSHHistorySource : NSObject <UITableViewDataSource>

@property NSString* path;

-(id) initWithContentsOfFile:(NSString*)path;
-(BOOL)writeToFile:(NSString *)path;

-(void) insertElement:(WSHReport*)element;
-(WSHReport*) elementAtIndex:(NSUInteger)index;

-(void) removeElementAtIndex:(NSUInteger)index;
-(void) removeAllElements;

-(NSUInteger) count;


@end
