//
//  WSHMenuPanelViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/13/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHMenuPanelViewController.h"
#import "WSHAboutViewController.h"
#import "WSHR10FormViewController.h"
#import "WSHDebugFormViewController.h"
#import "WSHFeedbackViewController.h"
#import "WSHAppDelegate.h"
#import "JASidePanelController.h"

@interface WSHMenuPanelViewController ()

@property NSIndexPath* selectedIndexPath;

@end

@implementation WSHMenuPanelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    // set the frame size
    
    [self autosizeMenu];
    
    [self applyMotif];
}

-(void)applyMotif
{
    self.tableView.backgroundColor = [UIColor menuViewBackground];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self autosizeMenu];
}

-(void)autosizeMenu
{
    WSHAppDelegate* appDelegate = (WSHAppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect frame = self.tableView.frame;
    frame.size.width = floorf(frame.size.width * appDelegate.viewController.rightGapPercentage);
    self.tableView.frame = frame;
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
#ifdef DEBUG
    return 3;
#else
    return 2; // hide the Debug section
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
#ifdef TESTING
            return 2;
#else
            return 1; // hide the Feedback row
#endif
        case 2:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    NSString* text = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

        
        UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        bg.opaque = NO;
//        bg.backgroundColor = [UIColor menuButtonBackground];
////        bg.layer.borderColor = [UIColor menuButtonBorder].CGColor;
////        bg.layer.cornerRadius = 10;
        [cell setBackgroundView:bg];
        cell.textLabel.backgroundColor = [UIColor clearColor];
//
//        
        UIView* sel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//        sel.opaque = YES;
//        sel.backgroundColor = [UIColor menuButtonSelectedBackground];
////        sel.layer.cornerRadius = 10;
//        sel.layer.borderWidth = 1.5f;
//        sel.layer.borderColor = [UIColor menuButtonSelectedBorder].CGColor;
        [cell setSelectedBackgroundView:sel];
        [cell.textLabel setHighlightedTextColor:[UIColor menuButtonSelectedTextColor]];
        [cell.selectedBackgroundView setBackgroundColor:[UIColor menuButtonSelectedBackground]];
        
        
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    text = @"Rule of Ten";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    text = @"About";
                    break;
                case 1:
                    text = @"Send Feedback";
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    text = @"Debug";
                    break;
            }
    }
    [cell.textLabel setText:text];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    WSHAppDelegate* appDelegate = (WSHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // don't reload a viewController if we selected the same thing
    if (self.selectedIndexPath.section == indexPath.section &&
        self.selectedIndexPath.row == indexPath.row) {
        [appDelegate.viewController showCenterPanelAnimated:YES];
        return;
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    appDelegate.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[WSHR10FormViewController alloc] init]];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    appDelegate.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[WSHAboutViewController alloc] initWithNibName:@"WSHAboutViewController" bundle:nil]];
                    break;
                case 1:
                    //[TestFlight openFeedbackView];
                    appDelegate.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[WSHFeedbackViewController alloc] initWithNibName:@"WSHFeedbackViewController" bundle:nil]];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    appDelegate.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[WSHDebugFormViewController alloc] init]];
                    break;
            }
    }
    
    [TestFlight passCheckpoint:
     [NSString stringWithFormat:@"Switched to view '%@'",
      [self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text]];
    
    self.selectedIndexPath = indexPath;
}

@end
