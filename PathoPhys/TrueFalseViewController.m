//
//  TrueFalseViewController.m
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "TrueFalseViewController.h"
#import "TRUEFLASE.h"
#import "Feedback.h"
#import "TestYourSelfViewController.h"

@interface TrueFalseViewController ()
{
    TRUEFLASE *objTrueFalse;
    Feedback *objFeedback;    
    BOOL select;
    NSInteger answer;
    NSInteger userAnswer;
    NSString *strFeedback;
    UIView *feedbackView;
    UIButton *btnInvisible;
    NSInteger currentOrientaion;
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    float y_feedback_p;
    float y_feedback_l;
    
    
    float x_feedback_p;
    float x_feedback_l;
    
    

}
@end
@implementation TrueFalseViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize parentObject;
@synthesize intVisited;
@synthesize strVisitedAnswer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblQuestionText.text = objTrueFalse.strQuestionText ;
    
    [self fn_SetFontColor];
    
  	[webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Select the correct image and tap <b>Submit.</b>" baseURL:nil];
    
    [self fn_hideAnsFeedbackImages];
    select = YES;
    
    objTrueFalse.strAnswer = [objTrueFalse.strAnswer uppercaseString];
    
    if ([objTrueFalse.strAnswer isEqualToString:@"FALSE"]) {
        answer = 2;
    }
    else {
        answer = 1;
    }
    [self Fn_createInvisibleBtn];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) fn_SetFontColor
{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    lblQuestionNo.font = FONT_31;
    lblQuestionText.font = FONT_17;
    
}

-(void) Fn_createInvisibleBtn
{
    btnInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInvisible setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    btnInvisible.backgroundColor = [UIColor clearColor];
    [btnInvisible addTarget:self action:@selector(onInvisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvisible];
    btnInvisible.hidden = YES;
}

-(IBAction)onInvisible:(id)sender
{
    btnInvisible.hidden = YES;
    //feedbackView.hidden = YES;
}

- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue{
    
    [feedbackView removeFromSuperview];
    
    feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 261, 131)];
    feedbackView.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    [bg setFrame:CGRectMake(13, 13, 235, 104)];
    [feedbackView addSubview:bg];
    
    
    UIImageView *img_feedback = [[UIImageView alloc] init];
    img_feedback.backgroundColor = [UIColor clearColor];
    [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
    [img_feedback setFrame:CGRectMake(0, 0, 261, 131)];
    [feedbackView addSubview:img_feedback];
    
    
    UITextView *txt_feedback = [[UITextView alloc] init];
    txt_feedback.text = textValue;
    txt_feedback.textColor = [UIColor whiteColor];
    txt_feedback.backgroundColor = [UIColor clearColor];
    txt_feedback.font = FONT_14;
    txt_feedback.editable = NO;
    [txt_feedback setFrame:CGRectMake(13, 13, 235, 104)];
    [feedbackView addSubview:txt_feedback];
    [self.view addSubview:feedbackView];
    
    btnInvisible.hidden = NO;
}
- (NSString *) fn_getFeeback:(BOOL)boolfeed
{
    NSString *strTemp = nil;
    
    for (int x=0; x<objTrueFalse.arrFeedback.count; x++) {
        objFeedback =  [objTrueFalse.arrFeedback objectAtIndex:x];
        NSString *trimmedString = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        trimmedString = [trimmedString lowercaseString];
        if (boolfeed == [trimmedString boolValue]) {
            return objFeedback.strFeedback;
        }
        
    }
    
    return strTemp;
}

-(IBAction)onFeedbackTapped:(id)sender
{
    UIButton *bn = sender;
    float x_point = bn.frame.origin.x - 220;
    float y_point = bn.frame.origin.y - 130;
    
    x_feedback_l = x_point + 20;
    y_feedback_l = y_point; //OK

    x_feedback_p = x_point - 110;
    y_feedback_p = y_point + 80;
    
    
    if(currentOrientaion==0 || currentOrientaion==1) // Portrait
    {
        [self Fn_AddFeedbackPopup:x_feedback_p andy:y_feedback_p andText:strFeedback];
    }
    else //Lanscape
    {
        [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:strFeedback];
    }
    


}
//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
    objTrueFalse = [db fnGetTestyourselfTrueFalse:question_id];
}
//--------------------------------

-(void)fn_hideAnsFeedbackImages
{
    [imgViewCorrect setImage:nil];
    bnFeedback.hidden = YES;
}

- (void) handleShowAnswers{
    
}

- (void) handleRevealScore {
    
    if (answer == userAnswer) {
        [imgViewCorrect setImage:[UIImage imageNamed:@"img_true.png"]];
    }
    else {
        [imgViewCorrect setImage:[UIImage imageNamed:@"img_false.png"]];
    }
    
    strFeedback = nil;
    
    if (userAnswer == 1) {
        strFeedback = [self fn_getFeeback:true];
    }
    else if (userAnswer == 2) {
        strFeedback = [self fn_getFeeback:false];
    }     
    
    if (strFeedback.length > 0) {
        bnFeedback.hidden = NO;
    }
    
    [self disableEditFields];
}

- (void) disableEditFields{
    bnFalse.enabled = NO;
    bnTrue.enabled = NO;
}

-(void) fn_CheckAnswersBeforeSubmit
{
    if (select) {
        intVisited = 0;
    }
    else  {
        if (answer == userAnswer) {
            intVisited = 1;
        }
        else {
            intVisited = 2;
        }
    }
}
-(void) fn_OnSubmitTapped
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Message"];
    [alert setDelegate:self];
    if (select) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please select options"]];
    }
    else {
        if (answer == userAnswer) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"That's Correct!"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"That's Incorrect!"]];
        }
    }
	[alert show];

}

-(IBAction)onTrueFalse:(id)sender;
{
    select = NO;
    userAnswer = [sender tag];
    if ([sender tag] == 1) {
        UIImage *imgTrueH = [UIImage imageNamed:@"btn_true_highlight.png"];
        [bnTrue setImage:imgTrueH forState:UIControlStateNormal];
        UIImage *imgFalseA = [UIImage imageNamed:@"btn_false_active.png"];
        [bnFalse setImage:imgFalseA forState:UIControlStateNormal];
    }
    else if ([sender tag] == 2) {        
        UIImage *imgTrueA = [UIImage imageNamed:@"btn_true_active.png"];
        [bnTrue setImage:imgTrueA forState:UIControlStateNormal];
        UIImage *imgFalseH = [UIImage imageNamed:@"btn_false_highlight.png"];
        [bnFalse setImage:imgFalseH forState:UIControlStateNormal];
    }
}
-(IBAction)onFeedback:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Message"];
    [alert setDelegate:self];

    if (answer == userAnswer) {
        [alert setTag:4];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"That's Correct!"]];
    }
    else {
        [alert setTag:5];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"That's Incorrect!"]];
    }
   
	[alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];
            [self handleRevealScore];
        }
    }
    else if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}


#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger mask= UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    currentOrientaion = interfaceOrientation;
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        
        mask  |= UIInterfaceOrientationMaskLandscapeLeft;
        
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
       	[self Fn_rotateLandscape];
        mask |= UIInterfaceOrientationMaskLandscapeRight;
        
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
     	[self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortraitUpsideDown;
        
	}
	else {
        [self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortrait;
        
	}
    return UIInterfaceOrientationMaskAll;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    currentOrientaion = interfaceOrientation;
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        return YES;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        return YES;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        return YES;
	}
	else {
        [self Fn_rotatePortrait];
        return YES;
	}
    
	return YES;
}
//------------------------------
/*
-(void)Fn_rotatePortrait
{
    [lblQuestionNo setFrame:CGRectMake(17, 25, 93, 114) ];
    [lblQuestionText setFrame:CGRectMake(118, 25, 567, 114) ];    
   
    [ImgQuestionBg setImage:[UIImage imageNamed:@"text-box.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 17, 767, 803)];
    
    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"blue_5text_bar.png"]];
    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 767, 177)];
    
    [webviewInstructions setFrame:CGRectMake(19, 190, 725, 45)];
    
    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator_P.png"]];
    [ImgQuestionSeperator setFrame:CGRectMake(4, 225, 767, 53)];
    [bnTrue setFrame:CGRectMake(136, 318, 237, 297)];
    [bnFalse setFrame:CGRectMake(391, 318, 237, 297)];
    [bnFeedback setFrame:CGRectMake(707, 414, 73, 44) ];
    [imgViewCorrect setFrame:CGRectMake(666, 423, 36, 25)];
    
}
-(void)Fn_rotateLandscape
{
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75) ];
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72) ];
    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 32) ];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
    [ImgQuestionBg setImage:[UIImage imageNamed:@"img_question_bg.png"]];
    
    [ImgQuestionTextBg setFrame:CGRectMake(0, 17, 1005, 75)];
    [ImgQuestionTextBg setImage:[UIImage imageNamed:@"img_questiontext2_bg.png"]];
    
    [ImgQuestionSeperator setFrame:CGRectMake(13, 128, 977, 54)];
    [ImgQuestionSeperator setImage:[UIImage imageNamed:@"img_question_seperator.png"]];
    [bnTrue setFrame:CGRectMake(256, 218, 237, 297)];
    [bnFalse setFrame:CGRectMake(511, 218, 237, 297)];
    [bnFeedback setFrame:CGRectMake(907, 314, 73, 44) ];
    [imgViewCorrect setFrame:CGRectMake(766, 323, 36, 25)];
    
}
*/

-(void)Fn_rotatePortrait
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg_p.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 767, 803)];
    
    // Instruction
     [webviewInstructions setFrame:CGRectMake(19, 130, 725, 70)];
    
    // Feedback
    //[feedbackView setFrame:CGRectMake(feedbackView.frame.origin.x, y_feedback_p, 261, 131)];
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(125, 20, 570, 72)];
    
    //
    [bnTrue setFrame:CGRectMake(136, 318, 237, 297)];
    [bnFalse setFrame:CGRectMake(391, 318, 237, 297)];
    [bnFeedback setFrame:CGRectMake(690, 414, 73, 44) ];
    [imgViewCorrect setFrame:CGRectMake(650, 423, 36, 25)];
}
-(void)Fn_rotateLandscape
{
    // Self View
    [self.view setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Question Bg
    [ImgQuestionBg setImage:[UIImage imageNamed:@"question_bg.png"]];
    [ImgQuestionBg setFrame:CGRectMake(0, 0, 1005, 600)];
    
    // Instruction
    [webviewInstructions setFrame:CGRectMake(17, 93, 968, 45)];
    
    // Feedback
    //[feedbackView setFrame:CGRectMake(feedbackView.frame.origin.x, y_feedback_l, 261, 131)];
    [feedbackView setFrame:CGRectMake(x_feedback_l, y_feedback_l, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72)];
    
    //
    [bnTrue setFrame:CGRectMake(256, 218, 237, 297)];
    [bnFalse setFrame:CGRectMake(511, 218, 237, 297)];
    [bnFeedback setFrame:CGRectMake(820, 324, 73, 44) ];
    [imgViewCorrect setFrame:CGRectMake(766, 333, 36, 25)];
    
}
@end
