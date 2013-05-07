//
//  DragDropViewController.m
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "DragDropViewController.h"
#import "DRAGDROP.h"
#import "Feedback.h"
#import <QuartzCore/QuartzCore.h>
#import "DragDropManager.h"
#import "CustomDragButton.h"
#import "TestYourSelfViewController.h"

@interface DragDropViewController ()
{
    DRAGDROP *objDRAGDROP;
    Feedback *objFeedback;    
    NSMutableArray *draggableSubjects;
    NSMutableArray *droppableAreas;
    DragDropManager *_dragDropManager;
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    UIView *feedbackView;
    CGRect visibleRect;
    NSInteger currentOrientaion;
    UIPanGestureRecognizer * uiTapGestureRecognizer;
    
    float y_feedback_p;
    float y_feedback_l;
    float x_feedback_p;
    float x_feedback_l;
}
- (void) Fn_disableAllDraggableSubjects;
- (void) rotateScrollViewButtonsForiPhone;


@property(nonatomic, retain) DragDropManager *dragDropManager;

@end


@implementation DragDropViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;

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
    lblQuestionText.text = objDRAGDROP.strQuestionText ;
    
    [self fn_SetFontColor];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:10px;color:AA3934;font-family:helvetica;\">Drag the options and drop them on the correct drop areas. Once you are done, tap <b>Submit.</b></body></html>" baseURL:nil];       

    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Drag the options and drop them on the correct drop areas. Once you are done, tap <b>Submit.</b></body></html>" baseURL:nil];
        
    }
    
    UIImage *imgName = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objDRAGDROP.strImageName]];
    imgViewQue.image = imgName;
    [imgViewQue setFrame:CGRectMake(0, 10, imgName.size.width, imgName.size.height)];
    [imgDropView setFrame:imgViewQue.frame];
    [imgDropView setBackgroundColor:COLOR_CLEAR];
    [imgScroller setContentSize:CGSizeMake(imgScroller.frame.size.width, imgViewQue.frame.size.height)];
    
    draggableSubjects = [[NSMutableArray alloc] init];
    droppableAreas = [[NSMutableArray alloc] init];
    
    [self draggblePoints];
    [self droppablePoints];
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [self rotateScrollViewButtonsForiPhone];
    }
    
}



- (void) Fn_disableAllDraggableSubjects{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
}


-(void) fn_SetFontColor
{
    lblQuestionNo.textColor = COLOR_WHITE;
    lblQuestionText.textColor = COLOR_WHITE;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lblQuestionNo.font = FONT_20;
        lblQuestionText.font = FONT_12;
    }
    else {
        lblQuestionNo.font = FONT_31;
        lblQuestionText.font = FONT_17;
    }
    
}


- (void) draggblePoints
{
 
        int y = 10;
        for (int i = 0; i < [objDRAGDROP.arrOptions count]; i++){
            
            CustomDragButton *bnDrag = [CustomDragButton buttonWithType:UIButtonTypeCustom];
            bnDrag.frame = CGRectMake(0, y, objDRAGDROP.fWidth, objDRAGDROP.fHeight);
            bnDrag.exclusiveTouch = YES;
            bnDrag.tag = i+1;
            [bnDrag setTitle:[objDRAGDROP.arrOptions objectAtIndex:i] forState:UIControlStateNormal];
            [bnDrag setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            [bnDrag setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
            bnDrag.titleLabel.font = FONT_14;
            bnDrag.titleLabel.numberOfLines = 3;
            bnDrag.userInteractionEnabled=YES;
            
            [bnDrag.ansImage setFrame:CGRectMake(objDRAGDROP.fWidth-40, -10, 22, 22)];
            
            [bnDrag.feedbackBt setTag:i];
            bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, -15, 22, 22);
            [bnDrag.feedbackBt setTag:i];
            [bnDrag.feedbackBt setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
            bnDrag.feedbackBt.hidden = YES;
            [bnDrag.feedbackBt addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollViewDrag addSubview:bnDrag];
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                bnDrag.titleLabel.font = FONT_10;
                [bnDrag.ansImage setFrame:CGRectMake(objDRAGDROP.fWidth-40, -15, 22, 22)];
                
                bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, -15, 22, 22);
                y=y+objDRAGDROP.fHeight+2;
            }
            else {
                y=y+objDRAGDROP.fHeight+10;
            }

            
            [draggableSubjects addObject:bnDrag];
            
        }
        [scrollViewDrag setContentSize:CGSizeMake(objDRAGDROP.fWidth, y)];    
}

- (void) rotateScrollViewButtonsForLandscape{
    int counter= 0;
    int y = 10;
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            counter++;
            [myView removeFromSuperview];
            myView.frame = CGRectMake(20, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10   ;
        }
    }
}

- (void) rotateScrollViewButtonsForPortrait{
    int counter= 0;
    int y = 10, x= 20;

    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            counter++;
            [myView removeFromSuperview];
            myView.frame = CGRectMake(x, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10;
            if(counter == 3){ /// 3 --> Number of rows
                y = 10;
                x = x + myView.frame.size.width + 10;
                counter = 0;
            }
        }
    }
}

- (void) rotateScrollViewButtonsForiPhone{
    int counter= 0;
    int y = 5, x= 20;
    int numOfRows = 1;
    float bnwidth = 0;
    
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            bnwidth = myView.frame.size.width;
            counter++;
            
            [myView removeFromSuperview];
            myView.frame = CGRectMake(x, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10;
            if(counter == 2){ /// 3 --> Number of rows
                numOfRows++;
                y = 5;
                x = x + myView.frame.size.width + 10;
                counter = 0;
            }
        }
    }
    [scrollViewDrag setContentSize:CGSizeMake(20 + (numOfRows * bnwidth) + ((numOfRows-1) * 10), 93)];
    
}




- (void) droppablePoints
{
    for (int i=0; i<objDRAGDROP.arrXYpoints.count; i++) {
        
        NSArray *points = [[objDRAGDROP.arrXYpoints objectAtIndex:i] componentsSeparatedByString:@","];
        float x_point = [[points objectAtIndex:0] floatValue];
        float y_point = [[points objectAtIndex:1] floatValue];
        UIButton *bn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bn setFrame:CGRectMake(x_point, y_point, objDRAGDROP.fWidth, objDRAGDROP.fHeight)];        
        [bn setBackgroundColor:COLOR_CLEAR];
        [imgDropView addSubview:bn];
        [droppableAreas addObject:bn];
    }
    
    
    _dragDropManager = [[DragDropManager alloc] initWithDragSubjects:draggableSubjects andDropAreas:droppableAreas];
    
    uiTapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_dragDropManager action:@selector(dragging:)];
    [[self view] addGestureRecognizer:uiTapGestureRecognizer];

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSString *) fn_getFeeback:(int)intfeed AndCorrect:(NSString *)correctincorrect
{
    NSString *strTemp = nil;
    
    for (int x=0; x<objDRAGDROP.arrFeedback.count; x++) {
        objFeedback =  [objDRAGDROP.arrFeedback objectAtIndex:x];
        NSString *trimmedOption = [objFeedback.strOption stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        char letter = [trimmedOption characterAtIndex:0];
        int char_index = [md charToScore:letter] ;
        
        NSString *trimmedType = [objFeedback.strType stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        trimmedType = [trimmedType lowercaseString];
        
        if (intfeed == char_index) {
            if ([trimmedType isEqualToString:correctincorrect]) {
                strTemp = [NSString stringWithFormat:@"%@", objFeedback.strFeedback];
            }
        }
        
    }
    
    return strTemp;
}

- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue
{
    [feedbackView removeFromSuperview];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        feedbackView = [[UIView alloc] initWithFrame:CGRectMake(xValue, yValue, 150, 90)];
        feedbackView.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        [bg setFrame:CGRectMake(12, 12, 125, 65)];
        [feedbackView addSubview:bg];
        
        
        UIImageView *img_feedback = [[UIImageView alloc] init];
        img_feedback.backgroundColor = [UIColor clearColor];
        //        [img_feedback setImage:[UIImage imageNamed:@"img_feedback_down_box.png"]];
        
        [img_feedback setImage:[UIImage imageNamed:@"Small_Feedback_Box_004.png"]];
        
        [img_feedback setFrame:CGRectMake(0, 0, 150, 90)];
        [feedbackView addSubview:img_feedback];
        
        
        UITextView *txt_feedback = [[UITextView alloc] init];
        txt_feedback.text = textValue;
        txt_feedback.textColor = [UIColor whiteColor];
        txt_feedback.backgroundColor = [UIColor clearColor];
        txt_feedback.font = FONT_10;
        txt_feedback.editable = NO;
        [txt_feedback setFrame:CGRectMake(12, 12, 125, 65)];
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

-(IBAction)onFeedbackTapped:(id)sender
{
    CustomDragButton *bn = sender;
    float x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 10);
    float y_point = bn.superview.frame.origin.y + 15;
    y_point = y_point - visibleRect.origin.y;
    
    x_feedback_l=x_point;
    y_feedback_l=y_point;
    
    x_feedback_p=x_point-238;
    y_feedback_p=y_point+217;
    
    if(currentOrientaion==1 || currentOrientaion==2) // Portrait
    {
        [self Fn_AddFeedbackPopup:x_feedback_p andy:y_feedback_p andText:bn.strFeedback];
    }
    else //Lanscape
    {
        [self Fn_AddFeedbackPopup:x_feedback_l andy:y_feedback_l andText:bn.strFeedback];
    }
}



//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
   objDRAGDROP = [db fnGetTestyourselfDRAGDROP:question_id];
}
-(void) fn_CheckAnswersBeforeSubmit
{

	flagForAnyOptionSelect = NO;
    
    for (UIView *dropArea in _dragDropManager.dropAreas) {        
        if (dropArea.subviews.count == 0) {
            flagForAnyOptionSelect = YES;
        }        
    }    
    
    if (flagForAnyOptionSelect) {
        intVisited = 0;
    }
    else  {
        flagForCheckAnswer = [self checkForAnswer];
        if (flagForCheckAnswer == YES) {
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
    if (flagForAnyOptionSelect) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please drag and drop the items."]];
    }
    else {
        if (flagForCheckAnswer == YES) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:[NSString stringWithFormat:@"Correct"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Ok"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"Incorrect"]];
        }
    }
	[alert show];
}

- (BOOL) checkForAnswer{
    int i = 0;
    NSMutableString *strAns = [[NSMutableString alloc] init];
    BOOL flag1 = YES;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            UIButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                flag1 = NO;
                break;                
            }
            if (i == [objDRAGDROP.arrAnswer count] - 1)
                [strAns appendFormat:@"%@", ss];
            else
                [strAns appendFormat:@"%@#", ss];
        }        
        strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
        i++;
    }
    return flag1;
}
- (void) handleShowAnswers{
    
}

- (void) handleRevealScore{
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                [bn.ansImage setImage:[UIImage imageNamed:@"Btn_feed_false.png"]];
                NSString *feeback = [self fn_getFeeback:bn.tag AndCorrect:@"incorrect"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    [bn addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }else {
                [bn.ansImage setImage:[UIImage imageNamed:@"Btn_feed_true.png"]];
                NSString *feeback = [self fn_getFeeback:bn.tag AndCorrect:@"correct"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    [bn addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }
        }
        i++;
    }  
}
//--------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
            [self Fn_disableAllDraggableSubjects];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
            [self Fn_disableAllDraggableSubjects];
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}

# pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    feedbackView.hidden=YES;
    if (imgScroller == scrollView) {
        visibleRect.origin = imgScroller.contentOffset;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    feedbackView.hidden = YES;
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
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
//------------------------------

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
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(125, 20, 570, 72)];
    
    
    // ScrollView
    [imgScroller setFrame:CGRectMake(20, 370, 730, 360)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 730);
    [scrollViewDrag setFrame:CGRectMake(20, 220, 730, 150)];
    [self rotateScrollViewButtonsForPortrait];
    
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
    [feedbackView setFrame:CGRectMake(x_feedback_l, y_feedback_l, 261, 131)];
    
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [lblQuestionText setFrame:CGRectMake(118, 19, 867, 72)];
    
    // ScrollView
    //[scrollViewOptions setFrame:CGRectMake(150, 142, 954, 450)];
    //scrollViewOptions.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, scrollViewOptions.bounds.size.width - 830);
    
    // ScrollView
    [imgScroller setFrame:CGRectMake(280, 153, 727, 427)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 727);
    [scrollViewDrag setFrame:CGRectMake(5, 153, 270, 427)];
    
    [self rotateScrollViewButtonsForLandscape];
    
}
@end
