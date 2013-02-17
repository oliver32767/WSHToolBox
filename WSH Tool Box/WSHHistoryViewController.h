//
//  WSHHistoryViewController.h
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/14/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSHHistorySource.h"

@interface WSHHistoryViewController : UITableViewController <UIAlertViewDelegate>

- (id) initWithHistorySource:(WSHHistorySource*)source;


@end
