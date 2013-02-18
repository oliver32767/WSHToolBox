//
//  WSHHistoryViewController.m
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


#import "WSHHistoryViewController.h"

@interface WSHHistoryViewController ()

@property WSHHistorySource* source;
@property (weak) id<WSHHistorySourceDelegate> delegate;
@property BOOL hasBeenCleared;

@end

@implementation WSHHistoryViewController

-(id)initWithHistorySource:(WSHHistorySource *)source delegate:(id<WSHHistorySourceDelegate>)delegate
{
    self = [super init];
    if (self) {
        _hasBeenCleared = NO;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:
         [NSDateFormatter dateFormatFromTemplate:@"EdMMMyyyyhmma" options:0
                                          locale:[NSLocale currentLocale]]];
        _source = source;
        if (!_source) {
            _source = [[WSHHistorySource alloc] init];
        }
        if (_source.title) {
            self.title = _source.title;
        } else {
            self.title = @"History";
        }
        _delegate = delegate;
    }
    NSLog(@"Showing %d history element(s)", _source.count);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(onClear)];
    self.navigationItem.rightBarButtonItem = clearButton;
    if (_source.count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

-(void) onClear {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear History"
                                                    message:@"Are you sure you want to clear this forms history?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Clear", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _hasBeenCleared = YES;
        [_source removeAllForms];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    WSHFormData* form = [_source formAtIndex:_source.count - indexPath.row - 1]; //show them in reverse chronological order
    if (form.subtitle) {
        cell.textLabel.text = form.subtitle;
    } else if (form.title) {
        cell.textLabel.text = form.title;
    } else {
        cell.textLabel.text = @"Report";
    }
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:form.timestamp];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    WSHFormData* form = [_source formAtIndex:_source.count - indexPath.row - 1];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Retreived history item %d for %@", indexPath.row, _source.archiveKey]];
    [_delegate didSelectHistoryItem:form];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
