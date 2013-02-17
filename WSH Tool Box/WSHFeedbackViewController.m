//
//  WSHFeedbackViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/15/13.
//  Copyright (c) 2013 brtly.net. All rights reserved.
//

#import "WSHFeedbackViewController.h"
#import "WSHAppDelegate.h"
#import "JASidePanelController.h"

#define FEEDBACK_TAG 1
#define LABEL_TAG 2

@interface WSHFeedbackViewController ()

@end

@implementation WSHFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Feedback";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(onSend)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [self applyMotif];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self realignViews];
}

- (void)applyMotif
{
    UITextView* feedback = (UITextView*) [self.view viewWithTag:FEEDBACK_TAG];
    UILabel* label = (UILabel*) [self.view viewWithTag:LABEL_TAG];
    
    self.view.backgroundColor = [UIColor rootViewBackground];
    feedback.layer.cornerRadius = 10;
    [feedback.layer setBorderWidth:2.0f];
    [feedback.layer setBorderColor:[UIColor viewBorderColor].CGColor];

    [label setTextColor:[UIColor labelTextColor]];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self realignViews];
}

-(void)realignViews
{
    UIView* label = [self.view viewWithTag:LABEL_TAG];
    
    label.center = CGPointMake(self.view.frame.size.width/2, label.center.y);
}

-(void) onSend
{
    UITextView* feedback = (UITextView*) [self.view viewWithTag:FEEDBACK_TAG];
    
    if (feedback.text.length < 15) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Feedback Too Short"
                                                          message:@"Your message is too short. Please add some more feedback before trying to send."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        [TestFlight submitFeedback:feedback.text];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Feedback Sent"
                                                          message:@"Your message has been sent. Thank you fer helping to improve WSH Tool Box!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        feedback.text = @"";
        [self dismissKeyboard];
        WSHAppDelegate* appDelegate = (WSHAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.viewController showLeftPanelAnimated:YES];
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
