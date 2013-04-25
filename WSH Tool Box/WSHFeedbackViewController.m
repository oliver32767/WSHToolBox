//
//  WSHFeedbackViewController.m
//  WSH Tool Box
//
//  Created by Oliver Bartley on 2/15/13.
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


#import "WSHFeedbackViewController.h"
#import "WSHAppDelegate.h"
#import "JASidePanelController.h"

#define FEEDBACK_TAG 1
#define LABEL_TAG 2

@interface WSHFeedbackViewController ()

@end

@implementation WSHFeedbackViewController
{
    bool viewIsResized;
}
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
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"paper_plane_24.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onSend)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [self applyMotif];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    viewIsResized = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification  object:nil];
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
    
    if (feedback.text.length < 10) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Feedback Too Short"
                                                          message:@"Your message is too short. Please add some more feedback before trying to send.\n(10 char. minimum)"
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

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    UITabBarController* tabBarController = self.navigationController.tabBarController;
    UITextView* feedback = (UITextView*) [self.view viewWithTag:FEEDBACK_TAG];
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = feedback.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    keyboardFrame.size.height -= tabBarController.tabBar.frame.size.height;
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    feedback.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
//    buttonDone.enabled = true;
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
//    buttonDone.enabled = false;
    [self moveTextViewForKeyboard:aNotification up:NO];
}

/*
-(void) keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
//    CFShow(self.view);
    if (!viewIsResized) {
        CGRect frame = self.view.frame;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        frame.size.height -= keyboardFrame.size.height;
        if (self.tabBarController) { // consider if there is a tab bar below
            frame.size.height += self.tabBarController.tabBar.frame.size.height;
        }
        self.view.frame = frame;
        viewIsResized = YES;
    }
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)aNotification
{
//    CFShow(aNotification);
//    CFShow(self.view);
    NSDictionary * userInfo = aNotification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if (viewIsResized) {
        CGRect frame = self.view.frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        frame.size.height += keyboardFrame.size.height;
        if (self.tabBarController) {
            frame.size.height -= self.tabBarController.tabBar.frame.size.height;
        }
        self.view.frame = frame;  
        [UIView commitAnimations];
        viewIsResized = NO;
    }    
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
