//
//  FillInTheBlanksViewController.m
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "FillInTheBlanksViewController.h"
#import "FILLINBLANKS.h"
#import "Feedback.h"
#import "CustomDragButton.h"
#import "DragDropManager.h"
#import "TestYourSelfViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FillInTheBlanksViewController ()
{
    FILLINBLANKS *objFillBlanks;
    Feedback *objFeedback;
    
    NSMutableArray *draggableSubjects;
    NSMutableArray *droppableAreas;
    DragDropManager *_dragDropManager;
    UIPanGestureRecognizer * uiTapGestureRecognizer;    
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    UIView *feedbackView;
    CGRect visibleRect;
    NSInteger currentOrientaion;
    
    float y_feedback_p;
    float y_feedback_l;
    float x_feedback_p;
    float x_feedback_l;
    
}

@property(nonatomic, retain) DragDropManager *dragDropManager;
- (void) rotateScrollViewButtonsForiPhone;
@end

@implementation FillInTheBlanksViewController
@synthesize lblQuestionNo;
@synthesize lblQuestionText;
@synthesize webviewInstructions;
@synthesize strVisitedAnswer;
@synthesize intVisited;
@synthesize parentObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblQuestionText.text = objFillBlanks.strQuestionText ;
    
    [self fn_SetFontColor];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:10px;color:AA3934;font-family:helvetica;\">Drag the options and drop them on the correct blank areas. Once you are done, tap <b>Submit.</b> </body></html>" baseURL:nil];
        
    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:helvetica;\">Drag the options and drop them on the correct blank areas. Once you are done, tap <b>Submit.</b> </body></html>" baseURL:nil];
        
        }
    
    UIImage *imgName = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objFillBlanks.strImageName]];
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
    [scrollViewDrag.layer setBorderWidth:1.0];
    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
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
    for (int i = 0; i < [objFillBlanks.arrOptions count]; i++) {        
        
        CustomDragButton *bnDrag = [CustomDragButton buttonWithType:UIButtonTypeCustom];
        bnDrag.frame = CGRectMake(10, y, objFillBlanks.fWidth, objFillBlanks.fHeight);
        bnDrag.exclusiveTouch = YES;
        bnDrag.tag = i+1;
        [bnDrag setTitle:[objFillBlanks.arrOptions objectAtIndex:i] forState:UIControlStateNormal];
        [bnDrag setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        bnDrag.titleLabel.font = FONT_14;        
		[bnDrag setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
        bnDrag.userInteractionEnabled=YES;
        
      
        [bnDrag.ansImage setFrame:CGRectMake(objFillBlanks.fWidth-40, -15, 22, 22)];
        
        bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, -15, 22, 22);
        [bnDrag.feedbackBt setTag:i];
        [bnDrag.feedbackBt setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[bnDrag.feedbackBt setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        bnDrag.feedbackBt.hidden = YES;
        [bnDrag.feedbackBt addTarget:self action:@selector(onFeedbackTapped2:) forControlEvents:UIControlEventTouchUpInside];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            bnDrag.titleLabel.font = FONT_10;
            [bnDrag.ansImage setFrame:CGRectMake(objFillBlanks.fWidth-40, -15, 22, 22)];
            bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, -15, 22, 22);
            y=y+45+2;
        }
        else {
            y=y+45+10;
        }
        
        [scrollViewDrag addSubview:bnDrag];
        [draggableSubjects addObject:bnDrag];
        
    }

    [scrollViewDrag setContentSize:CGSizeMake(objFillBlanks.fWidth, y)];
    [scrollViewDrag.layer setBorderWidth:1.0];
    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
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
    int numOfColumns = 1;
    int bnWidth = 0;
    int bnHeight = 0;
    
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            bnWidth = myView.frame.size.width;
            bnHeight = myView.frame.size.height;
            counter++;
            [myView removeFromSuperview];
            myView.frame = CGRectMake(x, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            y = y + myView.frame.size.height + 10;
            if(counter == 3){ /// 3 --> Number of rows
                numOfColumns++;
                y = 10;
                x = x + myView.frame.size.width + 10;
                counter = 0;
            }
        }
    }
    
    [scrollViewDrag setContentSize:CGSizeMake(30 + (numOfColumns * bnWidth) + ((numOfColumns-1) * 10), 10 + (3 * bnHeight) + (2 *y))];
}




- (void) droppablePoints
{
    for (int i=0; i<objFillBlanks.arrXYpoints.count; i++) {
        
        NSArray *points = [[objFillBlanks.arrXYpoints objectAtIndex:i] componentsSeparatedByString:@","];
        float x_point = [[points objectAtIndex:0] floatValue];
        float y_point = [[points objectAtIndex:1] floatValue];
        UIView *bn = [[UIView alloc] init];
        [bn setFrame:CGRectMake(x_point, y_point, objFillBlanks.fWidth, objFillBlanks.fHeight)];
        [bn setBackgroundColor:[UIColor clearColor]];
        [imgDropView addSubview:bn];
        [droppableAreas addObject:bn];
    }
    
    
    _dragDropManager = [[DragDropManager alloc] initWithDragSubjects:draggableSubjects andDropAreas:droppableAreas];
    
    uiTapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_dragDropManager action:@selector(dragging:)];
    [[self view] addGestureRecognizer:uiTapGestureRecognizer];
    
}

- (void) Fn_disableAllDraggableSubjects{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
}

- (void) Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue
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


- (NSString *) fn_getFeeback:(int)intfeed AndCorrect:(NSString *)correctincorrect
{
    NSString *strTemp = nil;
    
    for (int x=0; x<objFillBlanks.arrFeedback.count; x++) {
        objFeedback =  [objFillBlanks.arrFeedback objectAtIndex:x];
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
-(IBAction)onFeedbackTapped:(id)sender
{
    CustomDragButton *bn = sender;
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objFillBlanks.fWidth - 157);
        y_point = bn.superview.frame.origin.y + 87;
        y_point = y_point - visibleRect.origin.y;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:bn.strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objFillBlanks.fWidth - 10);
        y_point = bn.superview.frame.origin.y + 15;
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
}

-(IBAction)onFeedbackTapped2:(id)sender
{
    UIButton *btn = sender;
    CustomDragButton *bn = [draggableSubjects objectAtIndex:btn.tag];
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objFillBlanks.fWidth - 132);
        y_point = bn.superview.frame.origin.y + 120;
        y_point = y_point - visibleRect.origin.y;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:bn.strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objFillBlanks.fWidth - 10);
        y_point = bn.superview.frame.origin.y + 15;
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
}

//Get db data from question_id
//--------------------------------
-(void) fn_LoadDbData:(NSString *)question_id
{
    objFillBlanks = [db fnGetTestyourselfFillInTheBlanks:question_id];
}
-(NSString *) fn_CheckAnswersBeforeSubmit
{
    
	flagForAnyOptionSelect = NO;
    NSMutableString *strTemp = [[NSMutableString alloc] init];
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        if (dropArea.subviews.count == 0) {
            flagForAnyOptionSelect = YES;
        }
        else {
            NSArray *arrSubviews = [dropArea subviews];
            if (arrSubviews.count > 0) {
                CustomDragButton *bn = [arrSubviews objectAtIndex:0];
                NSString *tempStr = [NSString stringWithFormat:@"%d$%d", bn.tag, dropArea.tag];
                [strTemp appendString:tempStr];
                if (i == [ _dragDropManager.dropAreas count]-1) {
                    
                }
                else {
                    [strTemp appendString:@"#"];
                }
            }
        }
        i++;
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
    
    return strTemp;
}
-(void) fn_OnSubmitTapped{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
    [alert setDelegate:self];
    if (flagForAnyOptionSelect) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please fill in the blanks."]];
    }
    else {
        if (flagForCheckAnswer == YES) {
            [alert setTag:2];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessage:MSG_CORRECT];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Answer"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:MSG_INCORRECT];
        }
    }
	[alert show];
}
-(void) fn_ShowSelected:(NSString *)visitedAnswers {
    NSArray *main;
    if (visitedAnswers.length > 0) {
        int i = 0;
        main = [visitedAnswers componentsSeparatedByString:@"#"];
        for (UIView *dropArea in _dragDropManager.dropAreas) {
            NSArray *sub = [[main objectAtIndex:i] componentsSeparatedByString:@"$"];
            int dragIndex = [[sub objectAtIndex:0] intValue];
            UIView *viewBeingDragged = [draggableSubjects objectAtIndex:dragIndex-1];
            [dropArea addSubview:viewBeingDragged];
            viewBeingDragged.frame = CGRectMake(0, 0, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
            i++;
        }
    }
    [self handleRevealScore];
    [self Fn_disableAllDraggableSubjects];
}

//--------------------------------


//--------------------------------
- (BOOL) checkForAnswer{
    int i = 0;
    BOOL flag1 = YES;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objFillBlanks.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                flag1 = NO;
            }
        }
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
            NSString *sa = [[objFillBlanks.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
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
//--------------------------------

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
    
    [webviewInstructions reload];
    
    
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
    [webviewInstructions reload];
    
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
    [imgScroller setFrame:CGRectMake(258, 153, 727, 427)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 727);
    [scrollViewDrag setFrame:CGRectMake(20, 153, 237, 427)];
     [self rotateScrollViewButtonsForLandscape];
}
@end





