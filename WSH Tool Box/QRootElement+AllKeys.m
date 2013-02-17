//
//  QRootElement+AllKeys.m
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



#import "QRootElement+AllKeys.h"

@implementation QRootElement (AllKeys)

// iterate over each element in each section, and add its key to an array, if possible
-(NSArray*)allElementKeys
{
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    
    NSEnumerator* s = [[self sections] objectEnumerator];
    NSEnumerator* e = nil;
    QSection* section = nil;
    QElement* element = nil;
    while (section = [s nextObject]) {
        e = [[section elements] objectEnumerator];
        while (element = [e nextObject]) {
            if ([element isKindOfClass:[QEntryElement class]]) {
                if ((QEntryElement*) element.key) {
                    [keys addObject:(QEntryElement*) element.key];
                }
            }
        }
    }
    return keys;
}

@end
