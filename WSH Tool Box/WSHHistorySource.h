//
//  WSHHistorySource.h
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
