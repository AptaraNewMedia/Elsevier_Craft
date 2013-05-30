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

#pragma mark - View lifecycle
//---------------------------------------------------------
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
    
    [scrollViewDrag.layer setBorderWidth:1.0];
    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//---------------------------------------------------------

#pragma mark - Common Function
//---------------------------------------------------------
-(void) fn_SetFontColor
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
-(void)draggblePoints
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
        [bnDrag.feedbackBt addTarget:self action:@selector(onFeedbackTapped2:) forControlEvents:UIControlEventTouchUpInside];
        
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
-(void)Fn_disableAllDraggableSubjects
{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
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
-(void)rotateScrollViewButtonsForiPhone
{
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
-(void)handleRevealScore
{
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas)
    {
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
//---------------------------------------------------------


#pragma mark - Public Function
//---------------------------------------------------------
-(void)fn_LoadDbData:(NSString *)question_id
{
   objDRAGDROP = [db fnGetTestyourselfDRAGDROP:question_id];
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
            [alert setMessage:[NSString stringWithFormat:@"Correct"]];
        }
        else {
            [alert setTag:3];
            [alert addButtonWithTitle:@"Answer"];
            [alert addButtonWithTitle:@"Try Again"];
            [alert setMessage:[NSString stringWithFormat:@"Incorrect"]];
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
-(void)handleShowAnswers
{
    int i = 0;
    for (CustomDragButton *bnDrag in draggableSubjects) {
        UIView *dropArea =  [_dragDropManager.dropAreas objectAtIndex:i];
        [dropArea addSubview:bnDrag];
        bnDrag.frame = CGRectMake(0, 0, bnDrag.frame.size.width, bnDrag.frame.size.height);
        
        [bnDrag.ansImage setImage:[UIImage imageNamed:@"Btn_feed_true.png"]];
        NSString *feeback = [self fn_getFeeback:bnDrag.tag AndCorrect:@"correct"];
        if (feeback.length > 0) {
            bnDrag.feedbackBt.hidden = NO;
            bnDrag.strFeedback = feeback;
            [bnDrag addTarget:self action:@selector(onFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        i++;
    }
}
//---------------------------------------------------------



#pragma mark - Button Actions
//---------------------------------------------------------
-(IBAction)onFeedbackTapped:(id)sender
{
    CustomDragButton *bn = sender;
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 157);
        y_point = bn.superview.frame.origin.y;// + 88;
        y_point = y_point - visibleRect.origin.y;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:bn.strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 10);
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
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 157);
        y_point = bn.superview.frame.origin.y;// + 120;
        y_point = y_point - visibleRect.origin.y;
        
        [self Fn_AddFeedbackPopup:x_point andy:y_point andText:bn.strFeedback];
    }
    else
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 10);
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
    NSLog(@"Portrait");
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
    //[scrollViewDrag setFrame:CGRectMake(5, 153, 270, 427)];
    [scrollViewDrag setFrame:CGRectMake(20, 153, 237, 427)];
    
    NSLog(@"Landscape");
    
    [self rotateScrollViewButtonsForLandscape];
    
}
//---------------------------------------------------------
@end
