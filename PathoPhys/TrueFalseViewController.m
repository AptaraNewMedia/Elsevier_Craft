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
    
    
    UIImage *imgTrue;
    UIImage *imgFalse;
}
@end
@implementation TrueFalseViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize parentObject;
@synthesize intVisited;
@synthesize strVisitedAnswer;

#pragma mark - View lifecycle
//---------------------------------------------------------
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblQuestionText.text = objTrueFalse.strQuestionText ;
    
    [self fn_SetFontColor];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:10px;color:AA3934;font-family:helvetica;\">Select the correct image and tap <b>Submit.</b>" baseURL:nil];
        
    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Select the correct image and tap <b>Submit.</b>" baseURL:nil];
    }
    
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
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
    

    
   if (objTrueFalse.intTrueid == 1 || objTrueFalse.intTrueid == 2 || objTrueFalse.intTrueid == 3 || objTrueFalse.intTrueid == 4) {
       
       if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        
           imgTrue = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone.png", objTrueFalse.strOptions1]];
           imgFalse = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone.png", objTrueFalse.strOptions2]];
           
       }
       else {
           
        switch (objTrueFalse.intTrueid) {
            case 1:
            {
                imgTrue = [UIImage imageNamed:@"140001_h.png"];
                imgFalse = [UIImage imageNamed:@"140001_l.png"];
                 
            }
                break;
                
            case 2:
            {
                imgTrue = [UIImage imageNamed:@"140002_h.png"];
                imgFalse = [UIImage imageNamed:@"140002_l.png"];

                
            }
                break;
                
            case 3:
            {
                imgTrue = [UIImage imageNamed:@"140003_h.png"];
                imgFalse = [UIImage imageNamed:@"140003_l.png"];
                
            }
                break;
            case 4:
            {
                imgTrue = [UIImage imageNamed:@"140004_h.png"];
                imgFalse = [UIImage imageNamed:@"140004_l.png"];
                
            }
                break;
        }
       
       }
        [bnTrue setImage:imgTrue forState:UIControlStateNormal];
        [bnFalse setImage:imgFalse forState:UIControlStateNormal];
        [bnTrue setFrame:CGRectMake(bnTrue.frame.origin.x, bnTrue.frame.origin.y, imgTrue.size.width, imgTrue.size.height)];
        [bnFalse setFrame:CGRectMake(bnFalse.frame.origin.x, bnFalse.frame.origin.y, imgFalse.size.width, imgFalse.size.height)];
   }
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//---------------------------------------------------------


#pragma mark - Common Function
//---------------------------------------------------------
-(void)fn_SetFontColor
{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lblQuestionNo.font = FONT_15;
        lblQuestionText.font = FONT_12;
    }
    else {
        lblQuestionNo.font = FONT_31;
        lblQuestionText.font = FONT_17;
    }
    
}
//---------------------------------------------------------


#pragma mark - Normal Function
//---------------------------------------------------------
-(void) Fn_createInvisibleBtn
{
    btnInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInvisible setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    btnInvisible.backgroundColor = [UIColor clearColor];
    [btnInvisible addTarget:self action:@selector(onInvisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInvisible];
    btnInvisible.hidden = YES;
}
-(void)Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue
{
    [feedbackView removeFromSuperview];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 180, 125)];
        
        feedbackView.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        [bg setFrame:CGRectMake(12, 17, 152, 90)];
        [feedbackView addSubview:bg];
        
        UIImageView *img_feedback = [[UIImageView alloc] init];
        img_feedback.backgroundColor = [UIColor clearColor];
        //        [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
        
        [img_feedback setImage:[UIImage imageNamed:@"Small_Feedback_Box_004.png"]];
        
        [img_feedback setFrame:CGRectMake(0, 0, 180, 125)];
        
        [feedbackView addSubview:img_feedback];
        
        UITextView *txt_feedback = [[UITextView alloc] init];
        txt_feedback.text = textValue;
        txt_feedback.textColor = [UIColor whiteColor];
        txt_feedback.backgroundColor = [UIColor clearColor];
        txt_feedback.font = FONT_10;
        txt_feedback.editable = NO;
        [txt_feedback setFrame:CGRectMake(12, 17, 152, 90)];
        [feedbackView addSubview:txt_feedback];
        [self.view addSubview:feedbackView];
    }
    else
    {
        feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 261, 131)];
        feedbackView.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        [bg setFrame:CGRectMake(13, 13, 235, 104)];
        [feedbackView addSubview:bg];
        
        
        UIImageView *img_feedback = [[UIImageView alloc] init];
        img_feedback.backgroundColor = [UIColor clearColor];
        [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
        
        //    [img_feedback setImage:[UIImage imageNamed:@"Small_Feedback_Box_004.png"]];
        
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
    }
}
-(NSString *)fn_getFeeback:(BOOL)boolfeed
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
-(void)fn_hideAnsFeedbackImages
{
    [imgViewCorrect setImage:nil];
    bnFeedback.hidden = YES;
}
-(void)fnSetTrueFalse
{
    if (objTrueFalse.intTrueid == 1 || objTrueFalse.intTrueid == 2 || objTrueFalse.intTrueid == 3 || objTrueFalse.intTrueid == 4) {
        
        //UIImage *imgHighlight = [UIImage imageNamed:@"truefalse_image_selection.png"];
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            if (userAnswer == 1) {
                imgTrue = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select_iphone.png", objTrueFalse.strOptions1]];
                imgFalse = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone.png", objTrueFalse.strOptions2]];
                
            }
            else if (userAnswer == 2) {
                imgTrue = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iphone.png", objTrueFalse.strOptions1]];
                imgFalse = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select_iphone.png", objTrueFalse.strOptions2]];
            }
            [bnTrue setImage:imgTrue forState:UIControlStateNormal];
            [bnFalse setImage:imgFalse forState:UIControlStateNormal];
            
        }
        else {
            
            if (userAnswer == 1) {
                imgTrue = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", objTrueFalse.strOptions1]];
                imgFalse = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objTrueFalse.strOptions2]];
                
            }
            else if (userAnswer == 2) {
                imgTrue = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objTrueFalse.strOptions1]];
                imgFalse = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", objTrueFalse.strOptions2]];
            }
            [bnTrue setImage:imgTrue forState:UIControlStateNormal];
            [bnFalse setImage:imgFalse forState:UIControlStateNormal];
            
            /*
             switch (objTrueFalse.intTrueid) {
             case 1:
             {
             imgTrue = [UIImage imageNamed:@"140001_h.png"];
             imgFalse = [UIImage imageNamed:@"140001_l.png"];
             }
             break;
             
             case 2:
             {
             imgTrue = [UIImage imageNamed:@"140002_h.png"];
             imgFalse = [UIImage imageNamed:@"140002_l.png"];
             
             }
             break;
             
             case 3:
             {
             imgTrue = [UIImage imageNamed:@"140003_h.png"];
             imgFalse = [UIImage imageNamed:@"140003_l.png"];
             
             }
             break;
             case 4:
             {
             imgTrue = [UIImage imageNamed:@"140004_h.png"];
             imgFalse = [UIImage imageNamed:@"140004_l.png"];
             
             }
             break;
             }
             
             
             if (userAnswer == 1) {
             [bnTrue setBackgroundImage:imgHighlight forState:UIControlStateNormal];
             [bnFalse setBackgroundImage:nil forState:UIControlStateNormal];
             }
             else if (userAnswer == 2) {
             [bnTrue setBackgroundImage:nil forState:UIControlStateNormal];
             [bnFalse setBackgroundImage:imgHighlight forState:UIControlStateNormal];
             }
             */
        }
        
    }
    else {
        if (userAnswer == 1) {
            UIImage *imgTrueH = [UIImage imageNamed:@"btn_true_highlight.png"];
            [bnTrue setImage:imgTrueH forState:UIControlStateNormal];
            UIImage *imgFalseA = [UIImage imageNamed:@"btn_false_active.png"];
            [bnFalse setImage:imgFalseA forState:UIControlStateNormal];
        }
        else if (userAnswer == 2) {
            UIImage *imgTrueA = [UIImage imageNamed:@"btn_true_active.png"];
            [bnTrue setImage:imgTrueA forState:UIControlStateNormal];
            UIImage *imgFalseH = [UIImage imageNamed:@"btn_false_highlight.png"];
            [bnFalse setImage:imgFalseH forState:UIControlStateNormal];
        }
    }
}
-(void)handleRevealScore
{
    
    if (answer == userAnswer) {
//        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
//            [imgViewCorrect setImage:[UIImage imageNamed:@"True_Btn_Without_Border.png"]];
//        }
//        else {
            [imgViewCorrect setImage:[UIImage imageNamed:@"img_true.png"]];
//        }
    }
    else {
//        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
//            [imgViewCorrect setImage:[UIImage imageNamed:@"false_Without_Border.png"]];
//        }
//        else {
            [imgViewCorrect setImage:[UIImage imageNamed:@"img_false.png"]];
 //       }
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
//---------------------------------------------------------



#pragma mark - Public Function
//---------------------------------------------------------
-(void)fn_LoadDbData:(NSString *)question_id
{
    objTrueFalse = [db fnGetTestyourselfTrueFalse:question_id];
}
-(NSString *)fn_CheckAnswersBeforeSubmit
{
    NSString *strTemp = nil;
    if (select) {
        intVisited = 0;
    }
    else  {
        strTemp = [NSString stringWithFormat:@"%d#0", userAnswer];
        if (answer == userAnswer) {
            intVisited = 1;
        }
        else {
            intVisited = 2;
        }
    }
    return strTemp;
}
-(void)fn_OnSubmitTapped
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
    [alert setDelegate:self];
    if (select) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please select the correct image."]];
    }
    else {
        if (answer == userAnswer) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:MSG_CORRECT]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"View"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:MSG_INCORRECT]];
        }
    }
	[alert show];
    
}
-(void)fn_ShowSelected:(NSString *)visitedAnswers
{
    NSArray *main;
    if (visitedAnswers.length > 0) {
        
        main = [visitedAnswers componentsSeparatedByString:@"#"];
        userAnswer = [[main objectAtIndex:0] intValue];
        [self fnSetTrueFalse];
        [self handleRevealScore];
        [self disableEditFields];
        [parentObject Fn_DisableSubmit];
        if (answer != userAnswer) {
            [parentObject Fn_ShowAnswer];
        }
    }
}
-(void)disableEditFields
{
    bnFalse.enabled = NO;
    bnTrue.enabled = NO;
}
-(void)handleShowAnswers
{
    userAnswer = answer;
    [self fnSetTrueFalse];
    [self handleRevealScore];
    [self disableEditFields];
}
//--------------------------------


#pragma mark - Button Actions
//---------------------------------------------------------
-(IBAction)onTrueFalse:(id)sender;
{
    select = NO;
    userAnswer = [sender tag];
    [self fnSetTrueFalse];
}
-(IBAction)onFeedback:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
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
-(IBAction)onFeedbackTapped:(id)sender
{
    UIButton *bn = sender;
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x - 150;
        y_point = bn.frame.origin.y - 123;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x - 220;
        y_point = bn.frame.origin.y - 130;
        
        x_feedback_l = x_point + 20;
        y_feedback_l = y_point; //OK
        
        //        x_feedback_p = x_point - 110;
        //        y_feedback_p = y_point + 80;
        
        x_feedback_p = x_feedback_l-130;
        
        y_feedback_p = y_feedback_l+90;
        
        if(currentOrientaion==1 || currentOrientaion==2) // Portrait
        {
            [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:strFeedback];
        }
        else //Lanscape
        {
            [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:strFeedback];
        }
    }
}

-(IBAction)onInvisible:(id)sender
{
    btnInvisible.hidden = YES;
    //feedbackView.hidden = YES;
}
//---------------------------------------------------------


#pragma mark - AlertView
//---------------------------------------------------------
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
            [parentObject Fn_ShowAnswer];
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}

//---------------------------------------------------------
#pragma mark - Touch
//---------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    feedbackView.hidden = YES;
}
//---------------------------------------------------------


#pragma mark - Orientation
//---------------------------------------------------------
-(BOOL)shouldAutorotate
{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
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
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
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
    [imgViewCorrect setFrame:CGRectMake(650, 423, 36, 35)];
    
    [feedbackView setHidden:YES];
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
    [imgViewCorrect setFrame:CGRectMake(766, 333, 36, 35)];
    [feedbackView setHidden:YES];
}
//---------------------------------------------------------
@end
