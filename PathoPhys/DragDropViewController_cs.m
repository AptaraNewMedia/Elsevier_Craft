//
//  DragDropViewController.m
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "DragDropViewController_cs.h"
#import "DRAGDROP.h"
#import "Feedback.h"
#import <QuartzCore/QuartzCore.h>
#import "DragDropManager.h"
#import "CustomDragButton.h"
#import "CaseStudyViewController.h"

@interface DragDropViewController_cs ()
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

@property(nonatomic, retain) DragDropManager *dragDropManager;

@end


@implementation DragDropViewController_cs
@synthesize lblQuestionNo;
@synthesize webQuestionText;
@synthesize webviewInstructions;
@synthesize intVisited;
@synthesize strVisitedAnswer;
@synthesize parentObject;

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

    int f_size = 16;    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        f_size = 12;
    }
        
    NSString *question = [NSString stringWithFormat:@"<html><body style=\"font-size:%dpx;color:white;font-family:helvetica;background-color:#0c64b1;\">%@</body></html>", f_size, objDRAGDROP.strQuestionText];
    
    [webQuestionText loadHTMLString:question baseURL:nil];
    
    webQuestionText.scrollView.showsHorizontalScrollIndicator = NO;
    webQuestionText.scrollView.bounces = NO;
    btnCasestudyText.hidden = YES;
    
    [self fn_SetFontColor];
    
    webviewInstructions.scrollView.showsHorizontalScrollIndicator = NO;
    webviewInstructions.scrollView.bounces = NO;
    [webviewInstructions loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"font-size:%dpx;color:AA3934;font-family:helvetica;\">Drag the options and drop them on the correct drop areas. Once you are done, tap <b>Submit.</b></body></html>", f_size] baseURL:nil];
    
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
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lblQuestionNo.font = FONT_15;
    }
    else {
        lblQuestionNo.font = FONT_31;
    }
    
}
//---------------------------------------------------------


#pragma mark - Normal Function
//---------------------------------------------------------
-(void)draggblePoints
{
    int y = 10;
    for (int i = 0; i < [objDRAGDROP.arrOptions count]; i++){
        
        CustomDragButton *bnDrag = [CustomDragButton buttonWithType:UIButtonTypeCustom];
        bnDrag.frame = CGRectMake(20, y, objDRAGDROP.fWidth, objDRAGDROP.fHeight);
        bnDrag.exclusiveTouch = YES;
        bnDrag.tag = i+1;
        [bnDrag setTitle:[objDRAGDROP.arrOptionsText objectAtIndex:i] forState:UIControlStateNormal];
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
        y=y+objDRAGDROP.fHeight+10;
        
        [draggableSubjects addObject:bnDrag];
        
    }
    [scrollViewDrag setContentSize:CGSizeMake(objDRAGDROP.fWidth, y)];
    [scrollViewDrag.layer setBorderWidth:1.0];
    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
}
-(void)droppablePoints
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
-(void)rotateScrollViewButtonsForLandscape
{
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
-(void)rotateScrollViewButtonsForPortrait
{
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
-(NSString *)fn_getFeeback:(int)intfeed AndCorrect:(NSString *)correctincorrect
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
-(void)Fn_AddFeedbackPopup:(float)xValue andy:(float)yValue andText:(NSString *)textValue
{
    
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
}
-(void)handleRevealScore
{
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            
            NSLog(@"Selected===========  %@", bn.titleLabel.text);
            NSLog(@"Answer ==========  %@ ", [objDRAGDROP.arrAnswer objectAtIndex:i]);
            
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
//---------------------------------------------------------


#pragma mark - Public Function
//---------------------------------------------------------
-(void)fn_LoadDbData:(NSString *)question_id
{
   objDRAGDROP = [db fnGetCasestudyDRAGDROP:question_id];
}
-(NSString *)fn_CheckAnswersBeforeSubmit
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
-(void)fn_OnSubmitTapped
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
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
            [alert setMessage:[NSString stringWithFormat:MSG_CORRECT]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Answer"];
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
    [parentObject Fn_DisableSubmit];
    int check =  [self checkForAnswer];
    if (!check) {
        [parentObject Fn_ShowAnswer];
    }
}
-(BOOL)checkForAnswer
{
    int i = 0;
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
        }
        i++;
    }
    return flag1;
}
-(void)Fn_disableAllDraggableSubjects
{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
}

-(void)handleShowAnswers
{
    int i = 0;
    
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        for(UIView *view in [dropArea subviews]) {
            [view removeFromSuperview];
        }
        
        NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        for (int x=0; x<draggableSubjects.count; x++) {
            CustomDragButton *viewBeingDragged = [draggableSubjects objectAtIndex:x];
            NSString *ss = [viewBeingDragged.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                [dropArea addSubview:viewBeingDragged];
                viewBeingDragged.frame = CGRectMake(0, 0, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                [viewBeingDragged.ansImage setImage:[UIImage imageNamed:@"Btn_feed_true.png"]];
                NSString *feeback = [self fn_getFeeback:viewBeingDragged.tag AndCorrect:@"correct"];
                if (feeback.length > 0) {
                    viewBeingDragged.feedbackBt.hidden = NO;
                    viewBeingDragged.strFeedback = feeback;
                    [viewBeingDragged addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                break;
            }
        }
        i++;
    }
    [self handleRevealScore];
}
//---------------------------------------------------------


#pragma mark - Button Actions
//---------------------------------------------------------
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
-(IBAction)onCasestudyTextTapped:(id)sender
{
    strCaseStudyText = objDRAGDROP.strCasestudyText;
    [md Fn_AddCaseStudyText];
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
            [self Fn_disableAllDraggableSubjects];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0)
        {
            [parentObject Fn_DisableSubmit];            
            [self handleRevealScore];
            [self Fn_disableAllDraggableSubjects];
            [parentObject Fn_ShowAnswer];            
        }
        else if (buttonIndex == 1)
        {
            [parentObject onTryAgain];
        }
    }
}
//---------------------------------------------------------


#pragma mark - scrollview delegate
//---------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    feedbackView.hidden=YES;
    if (imgScroller == scrollView) {
        visibleRect.origin = imgScroller.contentOffset;
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
    [webviewInstructions setFrame:CGRectMake(19, 138, 660, 55)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_p, y_feedback_p, 261, 131)];
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 20, 93, 75)];
    
    // Question text
    [webQuestionText setFrame:CGRectMake(125, 30, 615, 100)];
    
    // Casestudy_text
    [btnCasestudyText setFrame:CGRectMake(680, 138, 60, 44)];
    
    
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
    [webviewInstructions setFrame:CGRectMake(17, 93, 905, 45)];
    
    // Feedback
    [feedbackView setFrame:CGRectMake(x_feedback_l, y_feedback_l, 261, 131)];
    
    
    // Question No
    [lblQuestionNo setFrame:CGRectMake(17, 17, 93, 75)];
    
    // Question text
    [webQuestionText setFrame:CGRectMake(118, 19, 867, 72)];
    
    // Casestudy_text
    [btnCasestudyText setFrame:CGRectMake(922, 91, 60, 44)];
    
    // ScrollView
    [imgScroller setFrame:CGRectMake(258, 153, 727, 427)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 727);
    [scrollViewDrag setFrame:CGRectMake(20, 153, 237, 427)];
    [self rotateScrollViewButtonsForLandscape];
}
//---------------------------------------------------------

@end
