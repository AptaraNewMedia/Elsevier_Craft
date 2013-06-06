//
//  DragDropFIBViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 17/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "DragDropRadioViewController.h"
#import "DragDropRadio.h"
#import <QuartzCore/QuartzCore.h>
#import "DragDropManager.h"
#import "CustomDragButton.h"
#import "RadioView.h"
#import "Feedback.h"
#import "TestYourSelfViewController.h"

@interface DragDropRadioViewController ()
{
    DragDropRadio *objDRAGDROP;
    Feedback *objFeedback;
    UIImage *imgRadio;
    UIImage *imgRadioSelected;
    
    RadioView *objRadioView;
    NSMutableArray *draggableSubjects;
    NSMutableArray *draggableSubjectsCopy;
    NSMutableArray *droppableAreas;
    NSMutableArray *arr_radioButtons;
    
    DragDropManager *_dragDropManager;
    UIPanGestureRecognizer * uiTapGestureRecognizer;    
    
    BOOL flagForAnyOptionSelect;
    BOOL flagForCheckAnswer;
    
    UIView *feedbackView;
    int RadioOptions;
    NSInteger currentOrientaion;
    
    CGRect visibleRect;
    
    float y_feedback_p;
    float y_feedback_l;
    float x_feedback_p;
    float x_feedback_l;
    
    UIImage *imgFeedbackNormal;
    UIImage *imgFeedbackHighligted;
    UIImage *imgAnswerTrue;
    UIImage *imgAnswerFalse;
}

@property(nonatomic, retain) DragDropManager *dragDropManager;

@end


@implementation DragDropRadioViewController


@synthesize lblQuestionNo;
@synthesize lblQuestionText;
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
    
    // Do any additional setup after loading the view from its nib.
    lblQuestionText.text = objDRAGDROP.strQuestionText ;
    [self fn_SetFontColor];
    [self fn_SetVariables];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:12px;color:AA3934;font-family:arial;\">Drag the options and drop them on the correct drop areas. Select the correct category that it belongs to and tap <b>Submit.</b></body></html>" baseURL:nil];
     
    }
    else {
        [webviewInstructions loadHTMLString:@"<html><body style=\"font-size:15px;color:AA3934;font-family:arial;\">Drag the options and drop them on the correct drop areas. Select the correct category that it belongs to and tap <b>Submit.</b></body></html>" baseURL:nil];        
    }
    
    
    UIImage *imgName = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", objDRAGDROP.strImageName]];
    imgViewQue.image = imgName;
    [imgViewQue setFrame:CGRectMake(0, 0, imgName.size.width, imgName.size.height)];
    [imgDropView setFrame:imgViewQue.frame];
    [imgDropView setBackgroundColor:[UIColor clearColor]];
    [imgScroller setContentSize:CGSizeMake(imgScroller.frame.size.width, imgViewQue.frame.size.height)];
    
    draggableSubjects = [[NSMutableArray alloc] init];
    draggableSubjectsCopy = [[NSMutableArray alloc] init];
    droppableAreas = [[NSMutableArray alloc] init];
    
    imgRadio = [UIImage imageNamed:@"table_radio_Btn.png"];
    imgRadioSelected = [UIImage imageNamed:@"table_radio_Btn_select.png"];
    
    [self draggblePoints];
    [self droppablePoints];
    
    [self createRadioButtons];
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [self rotateScrollViewButtonsForiPhone];
    }
    
//    [scrollViewDrag.layer setBorderWidth:1.0];
//    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
    
    imgScroller.delegate= self;
    scrollViewDrag.delegate= self;
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
-(void)fn_SetVariables
{
    //images
    imgFeedbackNormal = [UIImage imageNamed:@"Btn_feed.png"];
    imgFeedbackHighligted = [UIImage imageNamed:@"btn_feedback_highlight.png"];
    imgAnswerTrue = [UIImage imageNamed:@"Btn_feed_true.png"];
    imgAnswerFalse = [UIImage imageNamed:@"Btn_feed_false.png"];
    
}
//---------------------------------------------------------


#pragma mark - Normal Function
//---------------------------------------------------------
-(void)draggblePoints
{
    int y = 10;
    int scrollHeight = 10;
    for (int i = 0; i < [objDRAGDROP.arrOptions count]; i++){
        
        CustomDragButton *bnDrag = [CustomDragButton buttonWithType:UIButtonTypeCustom];
        bnDrag.frame = CGRectMake(20, y, objDRAGDROP.fWidth, objDRAGDROP.fHeight+15);
        bnDrag.exclusiveTouch = YES;
        bnDrag.tag = i+1;
        bnDrag.backgroundColor = COLOR_CLEAR;
        bnDrag.userInteractionEnabled=YES;
        
        bnDrag.lblText.frame = CGRectMake(0, 15, objDRAGDROP.fWidth, objDRAGDROP.fHeight);
        bnDrag.lblText.text = [objDRAGDROP.arrOptions objectAtIndex:i];
        [bnDrag.lblText setBackgroundColor:COLOR_CUSTOMBUTTON_BLUE];
        bnDrag.lblText.textColor = COLOR_WHITE;
        bnDrag.lblText.textAlignment = UITextAlignmentCenter;
        bnDrag.lblText.font = FONT_14;
        bnDrag.lblText.numberOfLines = 5;

        
        [bnDrag.ansImage setFrame:CGRectMake(objDRAGDROP.fWidth-40, 0, 22, 22)];
        
        [bnDrag.feedbackBt setTag:i];
        bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, 0, 22, 22);
        [bnDrag.feedbackBt setTag:i];
        [bnDrag.feedbackBt setImage:imgFeedbackNormal forState:UIControlStateNormal];
        [bnDrag.feedbackBt setImage:imgFeedbackHighligted forState:UIControlStateHighlighted];
        bnDrag.feedbackBt.hidden = YES;
        
        NSString *feeback = [self fn_getFeeback2:bnDrag.feedbackBt.tag AndCorrect:@"correct"];
        bnDrag.strFeedback=feeback;
        
        [bnDrag.feedbackBt addTarget:self action:@selector(onFeedbackTapped2:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollViewDrag addSubview:bnDrag];
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            bnDrag.lblText.font = FONT_10;
            [bnDrag.ansImage setFrame:CGRectMake(objDRAGDROP.fWidth-40, 0, 22, 22)];
            
            bnDrag.feedbackBt.frame = CGRectMake(bnDrag.ansImage.frame.origin.x+bnDrag.ansImage.frame.size.width+1, 0, 22, 22);
            y = y+objDRAGDROP.fHeight+2;
            scrollHeight = scrollHeight+objDRAGDROP.fHeight+15+2;
        }
        else {
            y = y+objDRAGDROP.fHeight+10;
            scrollHeight = scrollHeight+objDRAGDROP.fHeight+15+10;
        }
        [draggableSubjects addObject:bnDrag];
        [draggableSubjectsCopy addObject:bnDrag];
        
    }
    [scrollViewDrag setContentSize:CGSizeMake(scrollViewDrag.frame.size.width, scrollHeight)];
//    [scrollViewDrag.layer setBorderWidth:1.0];
//    [scrollViewDrag.layer setBorderColor:[COLOR_DRAG_BORDER CGColor]];
}
-(void)droppablePoints
{
    for (int i=0; i<objDRAGDROP.arrXYpoints.count; i++) {
        
        NSArray *points = [[objDRAGDROP.arrXYpoints objectAtIndex:i] componentsSeparatedByString:@","];
        float x_point = [[points objectAtIndex:0] floatValue];
        float y_point = [[points objectAtIndex:1] floatValue];
        
        UIButton *bn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bn setFrame:CGRectMake(x_point, y_point-15, objDRAGDROP.fWidth, objDRAGDROP.fHeight+15)];
        [bn setBackgroundColor:[UIColor clearColor]];
        [imgDropView addSubview:bn];
        [droppableAreas addObject:bn];
        
    }
    
    _dragDropManager = [[DragDropManager alloc] initWithDragSubjects:draggableSubjects andDropAreas:droppableAreas];
    uiTapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_dragDropManager action:@selector(dragging:)];
    uiTapGestureRecognizer.delegate = self;
    [[self view] addGestureRecognizer:uiTapGestureRecognizer];
    
}
-(void)createRadioButtons
{
    
    
    arr_radioButtons = [[NSMutableArray alloc] init];
    
    
    //int feedWidth = 36;
    //int feedHeight = 39;
    
    float x, y;
    float xx, yy;
    int height, width;
    
    int spacingWidth = 91;
    int spacingHeight = 50;
    
    y = 30;
    
    float firstX;
    float firstY;
    float secondX;
    float secondY;
    float thirdX;
    float thirdY;
    
    
    RadioOptions = objDRAGDROP.arrRadioOptions.count;
    
    if (objDRAGDROP.intDRAGDROPRADIOid == 25) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            spacingWidth = 30;
            spacingHeight = objDRAGDROP.fHeight;
            x = objDRAGDROP.fWidth + 10;
            y = 80;
            height = 16;
            width = 16;
        }
        else {
            spacingWidth = 92;
            spacingHeight = objDRAGDROP.fHeight+5;
            x = objDRAGDROP.fWidth + 10;
            y = 21;
            height = 22;
            width = 22;
        }
        
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 26) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            spacingWidth = 45;
            spacingHeight = objDRAGDROP.fHeight;
            x = objDRAGDROP.fWidth + 10;
            y = 75;
            height = 16;
            width = 16;
        }
        else {
            spacingWidth = 100;
            spacingHeight = objDRAGDROP.fHeight;
            x = objDRAGDROP.fWidth + 10;
            y = 32;
            height = 22;
            width = 22;
            
        }
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 18) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            spacingWidth = 65;
            spacingHeight = objDRAGDROP.fHeight + 5;
            x = objDRAGDROP.fWidth + 10;
            y = 78;
            height = 22;
            width = 22;
        }
        else {
            spacingWidth = 130;
            spacingHeight = objDRAGDROP.fHeight;
            x = objDRAGDROP.fWidth + 10;
            y = 13;
            height = 22;
            width = 22;
        }
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 9) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            spacingWidth = 67;
            spacingHeight = objDRAGDROP.fHeight + 5;
            x = objDRAGDROP.fWidth + 10;
            y = 85;
            height = 22;
            width = 22;
        }
        else {
            spacingWidth = 160;
            spacingHeight = objDRAGDROP.fHeight-4;
            x = objDRAGDROP.fWidth + 10;
            y = 17;
            height = 22;
            width = 22;
        }
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 14)
    {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            RadioOptions = 2;
            spacingWidth = 150;
            height = 22;
            width = 22;
            
            firstX = 5;
            firstY = 35;
            secondX = 130;
            secondY = 78;
            thirdX = 5;
            thirdY = 120;
        }
        else
        {
            RadioOptions = 2;
            spacingWidth = 160;
            height = 22;
            width = 22;
            
            firstX = 304;
            firstY = 0;
            secondX = 315;
            secondY = 40;
            thirdX = 14;
            thirdY = 86;
        }
    }
    else if (objDRAGDROP.intDRAGDROPRADIOid == 15)
    {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            RadioOptions = 2;
            spacingWidth = 130;
            spacingHeight = objDRAGDROP.fHeight;
            height = 22;
            width = 22;
            
            firstX = 35;
            firstY = 52;
            secondX = 35;
            secondY = 96;
            thirdX = 52;
            thirdY = 138;
        }
        else
        {
            RadioOptions = 2;
            spacingWidth = 160;
            spacingHeight = objDRAGDROP.fHeight;
            height = 22;
            width = 22;
            
            firstX = 42;
            firstY = 57;
            secondX = 40;
            secondY = 101;
            thirdX = 406;
            thirdY = 101;
        }
    }
    
    if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
        
        for( int k =0; k < objDRAGDROP.arrRadioAnswers.count; k++){
            
            if (k == 0 )
            {
                x = firstX;
                y = firstY;
            }
            else if (k == 1 )
            {
                x = secondX;
                y = secondY;
            }
            else if (k == 2)
            {
                x = thirdX;
                y = thirdY;
            }
            
            NSArray *arrTemp = [[objDRAGDROP.arrRadioOptions objectAtIndex:k] componentsSeparatedByString:@","];
            
            UIFont *temp_font;
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
            {
                temp_font=FONT_12;
            }
            else
            {
                temp_font=FONT_14;
            }
            
            // Option 1
            objRadioView = [[RadioView alloc] init];
            objRadioView.backgroundColor = COLOR_CLEAR;
            [objRadioView setFrame:CGRectMake(x, y, spacingWidth, spacingHeight)];
            xx = 0;
            yy = (spacingHeight/2) - 5;
            [objRadioView.btnOption1 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption1 setTag:k];
            [objRadioView.btnOption1 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [objRadioView.btnOption1 setTitle:[arrTemp objectAtIndex:0] forState:UIControlStateNormal];
            
            UILabel *lbl1 =[[UILabel alloc] initWithFrame:CGRectMake(xx+width, yy, (spacingWidth/2)-width, height)];
            [lbl1 setText:[arrTemp objectAtIndex:0]];
            [lbl1 setTextColor:COLOR_BLUE];
            lbl1.backgroundColor  = COLOR_CLEAR;
            lbl1.font = temp_font;
            [objRadioView addSubview:lbl1];
            
            [objRadioView.ansImage1 setImage:nil];
            [objRadioView.ansImage1 setFrame:CGRectMake(objRadioView.btnOption1.frame.origin.x + width + 10, yy - 10, width, height)];
            
            xx = xx + spacingWidth/2;
            
            
            // Option 2
            
            [objRadioView.btnOption2 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption2 setTag:k];
            [objRadioView.btnOption2 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [objRadioView.btnOption1 setTitle:[arrTemp objectAtIndex:1] forState:UIControlStateNormal];
            
            UILabel *lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(xx+width, yy, (spacingWidth/2)-width, height)];
            [lbl2 setText:[arrTemp objectAtIndex:1]];
            [lbl2 setTextColor:COLOR_BLUE];
            lbl2.font = temp_font;
            lbl2.backgroundColor  = COLOR_CLEAR;
            [objRadioView addSubview:lbl2];
            
            [objRadioView.ansImage2 setImage:nil];
            [objRadioView.ansImage2 setFrame:CGRectMake(objRadioView.btnOption2.frame.origin.x + width + 10, yy - 10, width, height)];
            
            xx = xx + spacingWidth;
            
            objRadioView.btnOption3.hidden = YES;
            objRadioView.btnOption4.hidden = YES;
            objRadioView.btnOption5.hidden = YES;
            
            [imgDropView addSubview:objRadioView];
            
            [arr_radioButtons addObject:objRadioView];
            
            y = y + objDRAGDROP.fHeight + 10;
        }
    }
    else
    {
        for( int k =0; k < objDRAGDROP.arrRadioAnswers.count; k++)
        {
            
            // Option 1
            objRadioView = [[RadioView alloc] init];
            objRadioView.backgroundColor = COLOR_CLEAR;
            
            NSLog(@"x: %f  Y:%f  Height: %d", x, y, spacingHeight);
            [objRadioView setFrame:CGRectMake(x, y, spacingWidth*RadioOptions, spacingHeight)];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                xx = 5;
                yy = 0;
            }
            else {
                xx = 5;
                
                if(objDRAGDROP.intDRAGDROPRADIOid == 9 || objDRAGDROP.intDRAGDROPRADIOid == 18)
                {
                    yy = (spacingHeight/2)-5;
                }
                else
                {
                    yy = (spacingHeight/2);
                }
            }
            [objRadioView.btnOption1 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption1 setTag:k];
            [objRadioView.btnOption1 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [objRadioView.ansImage1 setImage:nil];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                [objRadioView.ansImage1 setFrame:CGRectMake(xx, yy + objRadioView.btnOption1.frame.size.height, width, height)];
                
                [objRadioView.btnFeedback1 setFrame:CGRectMake(xx, yy + objRadioView.btnOption1.frame.size.height + objRadioView.ansImage1.frame.size.height, width, height)];
            }
            else {
                [objRadioView.ansImage1 setFrame:CGRectMake(objRadioView.btnOption1.frame.origin.x + width + 10, yy+5, width, height)];
                
                [objRadioView.btnFeedback1 setFrame:CGRectMake(objRadioView.ansImage1.frame.origin.x + width + 10, yy+5, width, height)];
                
            }
            
            [objRadioView.btnFeedback1 setTag:k];
            [objRadioView.btnFeedback1 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            objRadioView.btnFeedback1.hidden = YES;
            objRadioView.btnOption1.enabled = YES;
            xx = xx + spacingWidth;
            
            
            // Option 2
            
            [objRadioView.btnOption2 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption2 setTag:k];
            [objRadioView.btnOption2 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [objRadioView.ansImage2 setImage:nil];
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                [objRadioView.ansImage2 setFrame:CGRectMake(xx, yy + objRadioView.btnOption2.frame.size.height, width, height)];
                
                [objRadioView.btnFeedback2 setFrame:CGRectMake(xx, yy + objRadioView.btnOption2.frame.size.height + objRadioView.ansImage2.frame.size.height, width, height)];
            }
            else {
                [objRadioView.ansImage2 setFrame:CGRectMake(objRadioView.btnOption2.frame.origin.x + width + 10, yy+5, width, height)];
                
                [objRadioView.btnFeedback2 setFrame:CGRectMake(objRadioView.ansImage2.frame.origin.x + width + 10, yy+5, width, height)];
            }
            [objRadioView.btnFeedback2 setTag:k];
            [objRadioView.btnFeedback2 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            objRadioView.btnFeedback2.hidden = YES;
            xx = xx + spacingWidth;
            
            
            // Option 3
            
            [objRadioView.btnOption3 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption3 setTag:k];
            [objRadioView.btnOption3 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [objRadioView.ansImage3 setImage:nil];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                [objRadioView.ansImage3 setFrame:CGRectMake(xx, objRadioView.btnOption3.frame.size.height , width, height)];
                
                [objRadioView.btnFeedback3 setFrame:CGRectMake(xx, objRadioView.btnOption3.frame.size.height + objRadioView.ansImage3.frame.size.height, width, height)];
            }
            else {
                [objRadioView.ansImage3 setFrame:CGRectMake(objRadioView.btnOption3.frame.origin.x + width + 10, yy+5, width, height)];
                
                [objRadioView.btnFeedback3 setFrame:CGRectMake(objRadioView.ansImage3.frame.origin.x + width + 10, yy+5, width, height)];
                
            }
            [objRadioView.btnFeedback3 setTag:k];
            [objRadioView.btnFeedback3 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            objRadioView.btnFeedback3.hidden = YES;
            xx = xx + spacingWidth;
            
            
            
            // Option 4
            [objRadioView.btnOption4 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption4 setTag:k];
            [objRadioView.btnOption4 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [objRadioView.ansImage4 setImage:nil];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                [objRadioView.ansImage4 setFrame:CGRectMake(xx, yy+objRadioView.btnOption4.frame.size.height, width, height)];
                
                [objRadioView.btnFeedback4 setFrame:CGRectMake(xx, yy+objRadioView.btnOption4.frame.size.height+objRadioView.ansImage4.frame.size.height, width, height)];
            }
            else {
                [objRadioView.ansImage4 setFrame:CGRectMake(objRadioView.btnOption4.frame.origin.x + width + 10, yy+5, width, height)];
                
                [objRadioView.btnFeedback4 setFrame:CGRectMake(objRadioView.ansImage4.frame.origin.x + width + 10, yy+5, width, height)];
                
            }
            [objRadioView.btnFeedback4 setTag:k];
            [objRadioView.btnFeedback4 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            objRadioView.btnFeedback4.hidden = YES;
            xx = xx + spacingWidth;
            
            
            // Option 5
            [objRadioView.btnOption5 setFrame:CGRectMake(xx, yy, width, height)];
            [objRadioView.btnOption5 setTag:k];
            [objRadioView.btnOption5 addTarget:self action:@selector(Fn_Radio_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [objRadioView.ansImage5 setImage:nil];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                [objRadioView.ansImage5 setFrame:CGRectMake(xx, yy+objRadioView.btnOption5.frame.size.height, width, height)];
                
                [objRadioView.btnFeedback5 setFrame:CGRectMake(xx, yy+objRadioView.btnOption5.frame.size.height+objRadioView.ansImage5.frame.size.height, width, height)];
                
            }
            else {
                [objRadioView.ansImage5 setFrame:CGRectMake(objRadioView.btnOption5.frame.origin.x + width + 10, yy+5, width, height)];
                
                [objRadioView.btnFeedback5 setFrame:CGRectMake(objRadioView.ansImage5.frame.origin.x + width + 10, yy+5, width, height)];
                
            }
            [objRadioView.btnFeedback5 setTag:k];
            [objRadioView.btnFeedback5 addTarget:self action:@selector(Fn_Feedback_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            objRadioView.btnFeedback5.hidden = YES;
            
            
            if(objDRAGDROP.intDRAGDROPRADIOid == 18 || objDRAGDROP.intDRAGDROPRADIOid == 9){
                
                //            UILabel *lbl1 =[[UILabel alloc] initWithFrame:CGRectMake(objRadioView.btnOption1.frame.origin.x+width, objRadioView.btnOption1.frame.origin.y, 90, height)];
                ////            [lbl1 setText:[objDRAGDROP.arrRadioOptions objectAtIndex:0]];
                //            [lbl1 setTextColor:COLOR_BLUE];
                //            lbl1.backgroundColor  = COLOR_CLEAR;
                //            lbl1.font = FONT_14;
                //            [objRadioView addSubview:lbl1];
                
                if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
                {
                }
                else {
                
                [objRadioView.ansImage1 setFrame:CGRectMake(objRadioView.ansImage1.frame.origin.x, objRadioView.ansImage1.frame.origin.y - 10, objRadioView.ansImage1.frame.size.width, objRadioView.ansImage1.frame.size.height)];
                
                [objRadioView.ansImage2 setFrame:CGRectMake(objRadioView.ansImage2.frame.origin.x, objRadioView.ansImage2.frame.origin.y - 10, objRadioView.ansImage2.frame.size.width, objRadioView.ansImage2.frame.size.height)];
                }
                
                //            UILabel *lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(objRadioView.btnOption2.frame.origin.x+width, objRadioView.btnOption2.frame.origin.y, 90, height)];
                ////            [lbl2 setText:[objDRAGDROP.arrRadioOptions objectAtIndex:1]];
                //            [lbl2 setTextColor:COLOR_BLUE];
                //            lbl2.backgroundColor  = COLOR_CLEAR;
                //            lbl2.font = FONT_14;
                //            [objRadioView addSubview:lbl2];
                
            }
            
            if (RadioOptions == 2) {
                objRadioView.btnOption3.hidden = YES;
                objRadioView.btnOption4.hidden = YES;
                objRadioView.btnOption5.hidden = YES;
            }
            else if (RadioOptions == 3) {
                objRadioView.btnOption4.hidden = YES;
                objRadioView.btnOption5.hidden = YES;
            }
            else if (RadioOptions == 4) {
                objRadioView.btnOption5.hidden = YES;
            }
            
            [imgDropView addSubview:objRadioView];
            
            [arr_radioButtons addObject:objRadioView];
            
            
            //        y = y + objDRAGDROP.fHeight + 20;
            
            //        if(k>3 && k<7)
            //        {
            //            y = y + objDRAGDROP.fHeight + 20;
            //        }
            //        else
            
            //NSLog(@"objDRAGDROP.arrRadioAnswers.count: %d",objDRAGDROP.arrRadioAnswers.count);
            
            /*
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
            {
                if (objDRAGDROP.intDRAGDROPRADIOid == 25)
                {
                    if(k<=3)
                    {
                        y = y + objDRAGDROP.fHeight + 9;
                    }
                    else if(k>3 && k<9)
                    {
                        y = y + objDRAGDROP.fHeight+6;
                    }
                    else
                    {
                        y = y + objDRAGDROP.fHeight+7;
                    }
                }
                else
                {
                    if(k<1)
                    {
                        y = y + objDRAGDROP.fHeight + 10;
                    }
                    else
                    {
                        y = y + objDRAGDROP.fHeight + 5;
                    }
                }
            }
            else
            {
                y = y + objDRAGDROP.fHeight + 10;
            }
             
             */
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
            {
                if (objDRAGDROP.intDRAGDROPRADIOid == 25 || objDRAGDROP.intDRAGDROPRADIOid == 18) {
                    y = y + objDRAGDROP.fHeight + 8;
                }
                else if (objDRAGDROP.intDRAGDROPRADIOid == 9) {
                    y = y + objDRAGDROP.fHeight + 6;
                }
                else {
                    y = y + objDRAGDROP.fHeight + 5;
                }
                
            }
            
            else {
                y = y + objDRAGDROP.fHeight + 10;
                
            }
        }
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
    int numOfColumns = 1;
    int numOfRows = 4;
    float bnwidth = 0;
    float btnheight;
    
    for(UIView *myView in [scrollViewDrag subviews]){
        if([myView isKindOfClass:[CustomDragButton class]]){
            bnwidth = myView.frame.size.width;
            counter++;
            
            [myView removeFromSuperview];
            myView.frame = CGRectMake(x, y, myView.frame.size.width, myView.frame.size.height);
            [scrollViewDrag addSubview:myView];
            btnheight = myView.frame.size.height;
            y = y + myView.frame.size.height + 10;
            if(counter == numOfRows){
                numOfColumns++;
                y = 5;
                x = x + myView.frame.size.width + 10;
                counter = 0;
            }
        }
    }
    
    
    [scrollViewDrag setContentSize:CGSizeMake(20 + (numOfColumns * bnwidth) + ((numOfColumns-1) * 10), 5 + (numOfRows * btnheight) + numOfRows * 10)];
}
-(NSString *)fn_getFeeback:(NSMutableArray *)feedbackArr AndCorrect:(NSString *)correctincorrect Andfeed:(int)intfeed
{
    NSString *strTemp = nil;
    
    for (int x=0; x<feedbackArr.count; x++) {
        objFeedback =  [feedbackArr objectAtIndex:x];
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
-(NSString *)fn_getFeeback2:(int)intfeed AndCorrect:(NSString *)correctincorrect
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
        bg.backgroundColor = [UIColor clearColor];
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
        
        if(xValue<50)
        {
            img_feedback.transform = CGAffineTransformMakeScale(-1, 1);
            
            [feedbackView setFrame:CGRectMake(xValue+125, yValue, 180, 125)];
        }
        else
        {
            img_feedback.transform = CGAffineTransformMakeScale(1, 1);
        }
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
        
        if(xValue<200)
        {
            img_feedback.transform = CGAffineTransformMakeScale(-1, 1);
            
            [feedbackView setFrame:CGRectMake(xValue+230, yValue, 261, 131)];
            
            x_feedback_p=x_feedback_p+212;
            x_feedback_l=x_feedback_l+212;
        }
        else
        {
            img_feedback.transform = CGAffineTransformMakeScale(1, 1);
        }
    }
}
-(BOOL)checkForAnswer
{
    int i = 0;
    NSMutableString *strAns = [[NSMutableString alloc] init];
    BOOL flag1 = YES;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.lblText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        NSString *answer = [objDRAGDROP.arrRadioAnswers objectAtIndex:i];
        
        NSString *ss = [objRadioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			flag1 = NO;
		}
        if (i == [arr_radioButtons count] - 1)
            [strAns appendFormat:@"%@", ss];
        else
            [strAns appendFormat:@"%@#", ss];
    }
    strVisitedAnswer = [NSString stringWithFormat:@"%@",strAns];
    
    return flag1;
}
-(void)handleRevealScore
{
    
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        NSString *answer = [objDRAGDROP.arrRadioAnswers objectAtIndex:i];
        
        NSString *ss = [objRadioView.selected stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *sa = [answer  stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        UIImageView *ansImage =  nil;
        UIButton *bnFeedback = nil;
        
        switch (objRadioView.selectedIndex) {
            case 1:
                ansImage =  objRadioView.ansImage1;
                bnFeedback = objRadioView.btnFeedback1;
                break;
            case 2:
                ansImage =  objRadioView.ansImage2;
                bnFeedback = objRadioView.btnFeedback2;
                break;
            case 3:
                ansImage =  objRadioView.ansImage3;
                bnFeedback = objRadioView.btnFeedback3;
                break;
            case 4:
                ansImage =  objRadioView.ansImage4;
                bnFeedback = objRadioView.btnFeedback4;
                break;
            case 5:
                ansImage =  objRadioView.ansImage5;
                bnFeedback = objRadioView.btnFeedback5;
                break;
        }
        
        if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
			[ansImage setImage:imgAnswerFalse];
            
            NSString *feeback = [self fn_getFeeback:objDRAGDROP.arrFeedback AndCorrect:@"incorrect" Andfeed:objRadioView.selectedIndex];
            if (feeback.length > 0) {
                bnFeedback.hidden = NO;
                objRadioView.feedback = feeback;
            }
            
		}else {
			
			[ansImage setImage:imgAnswerTrue];
            
            NSString *feeback = [self fn_getFeeback:objDRAGDROP.arrFeedback AndCorrect:@"correct" Andfeed:objRadioView.selectedIndex];
            if (feeback.length > 0) {
                bnFeedback.hidden = NO;
                objRadioView.feedback = feeback;
            }
        }
        
        if(objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15){
            bnFeedback.hidden = YES;
        }
        
    }
    
    int i = 0;
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        NSArray *arrSubviews = [dropArea subviews];
        if (arrSubviews.count > 0) {
            CustomDragButton *bn = [arrSubviews objectAtIndex:0];
            NSString *ss = [bn.lblText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                [bn.ansImage setImage:imgAnswerFalse];
                NSString *feeback = [self fn_getFeeback2:bn.tag AndCorrect:@"incorrect"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    if(objDRAGDROP.intDRAGDROPRADIOid == 25 || objDRAGDROP.intDRAGDROPRADIOid == 26 || objDRAGDROP.intDRAGDROPRADIOid == 18 || objDRAGDROP.intDRAGDROPRADIOid == 9){
                    }
                    else {
                        [bn addTarget:self action:@selector(onFeedbackTapped3:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }
            }else {
                [bn.ansImage setImage:imgAnswerTrue];
                NSString *feeback = [self fn_getFeeback2:bn.tag AndCorrect:@"correct"];
                if (feeback.length > 0) {
                    bn.feedbackBt.hidden = NO;
                    bn.strFeedback = feeback;
                    if(objDRAGDROP.intDRAGDROPRADIOid == 25 || objDRAGDROP.intDRAGDROPRADIOid == 26 || objDRAGDROP.intDRAGDROPRADIOid == 18 || objDRAGDROP.intDRAGDROPRADIOid == 9){
                    }
                    else {
                        [bn addTarget:self action:@selector(onFeedbackTapped3:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }
            }
            
            if(objDRAGDROP.intDRAGDROPRADIOid == 25 || objDRAGDROP.intDRAGDROPRADIOid == 26 || objDRAGDROP.intDRAGDROPRADIOid == 18 || objDRAGDROP.intDRAGDROPRADIOid == 9){
                bn.feedbackBt.hidden = YES;
            }
        }
        i++;
    }
    
    [self disableEditFields];
}
//---------------------------------------------------------



#pragma mark - Public Function
//---------------------------------------------------------
-(void)fn_LoadDbData:(NSString *)question_id
{
    objDRAGDROP = [db fnGetTestyourselfDRAGDROPRadio:question_id];
}
-(NSString *)fn_CheckAnswersBeforeSubmit
{
    
	flagForAnyOptionSelect = NO;
    
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        if (dropArea.subviews.count == 0) {
            flagForAnyOptionSelect = YES;
        }
    }
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        if ([objRadioView.selected isEqualToString:@"0"]) {
            flagForAnyOptionSelect = YES;
            break;
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
    return nil;
}
-(void)fn_OnSubmitTapped
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:TITLE_COMMON];
    [alert setDelegate:self];
    if (flagForAnyOptionSelect) {
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please drag and drop and also select the category."]];
    }
    else {
        if (flagForCheckAnswer == YES) {
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

    
    [parentObject Fn_DisableSubmit];
    int check =  [self checkForAnswer];
    if (!check) {
        [parentObject Fn_ShowAnswer];
    }
}
-(void)Fn_disableAllDraggableSubjects
{
    for(UIButton *subview in [imgDropView subviews]) {
        [self.view removeGestureRecognizer:uiTapGestureRecognizer];
    }
}
-(void)disableEditFields
{
    
    for (int i =0; i <[arr_radioButtons count]; i++) {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        objRadioView.btnOption1.enabled = NO;
        objRadioView.btnOption2.enabled = NO;
        objRadioView.btnOption3.enabled = NO;
        objRadioView.btnOption4.enabled = NO;
        objRadioView.btnOption5.enabled = NO;
    }
}
-(void)handleShowAnswers
{
    // Drag Drop
    int i = 0;
    
    for (UIView *dropArea in _dragDropManager.dropAreas) {
        for(UIView *view in [dropArea subviews]) {
            [view removeFromSuperview];
        }
        
        NSString *sa = [[objDRAGDROP.arrAnswer objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        for (int x=0; x<draggableSubjects.count; x++) {
            CustomDragButton *viewBeingDragged = [draggableSubjects objectAtIndex:x];
            NSString *ss = [viewBeingDragged.lblText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([[ss lowercaseString] isEqualToString:[sa lowercaseString]]) {
                [dropArea addSubview:viewBeingDragged];
                viewBeingDragged.frame = CGRectMake(0, 0, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                [viewBeingDragged.ansImage setImage:imgAnswerTrue];
                NSString *feeback = [self fn_getFeeback2:viewBeingDragged.tag AndCorrect:@"correct"];
                if (feeback.length > 0) {
                    viewBeingDragged.feedbackBt.hidden = NO;
                    viewBeingDragged.strFeedback = feeback;
                    [viewBeingDragged addTarget:self action:@selector(onFeedbackTapped3:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
                [draggableSubjects removeObjectAtIndex:x];
                
                break;
            }
        }
        i++;
    }
    
    // Radio    
    for (int i =0; i <[arr_radioButtons count]; i++)
    {
        objRadioView = [arr_radioButtons objectAtIndex:i];
        NSString *answer = [objDRAGDROP.arrRadioAnswers objectAtIndex:i];
        
        [objRadioView.btnOption1 setImage:imgRadio forState:UIControlStateNormal];
        [objRadioView.btnOption2 setImage:imgRadio forState:UIControlStateNormal];
        [objRadioView.btnOption3 setImage:imgRadio forState:UIControlStateNormal];
        [objRadioView.btnOption4 setImage:imgRadio forState:UIControlStateNormal];
        [objRadioView.btnOption5 setImage:imgRadio forState:UIControlStateNormal];

        objRadioView.btnFeedback1.hidden = YES;
        objRadioView.btnFeedback2.hidden = YES;
        objRadioView.btnFeedback3.hidden = YES;
        objRadioView.btnFeedback4.hidden = YES;
        objRadioView.btnFeedback5.hidden = YES;
        
        [objRadioView.ansImage1 setImage:nil];
        [objRadioView.ansImage2 setImage:nil];
        [objRadioView.ansImage3 setImage:nil];
        [objRadioView.ansImage4 setImage:nil];
        [objRadioView.ansImage5 setImage:nil];
        
        for (int x=0; x<objDRAGDROP.arrRadioOptions.count ; x++) {
            NSString *ss = [[objDRAGDROP.arrRadioOptions objectAtIndex:x]stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *sa = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([ss isEqualToString:sa]) {
                switch (x) {
                        case 0:
                            [objRadioView.btnOption1 setImage:imgRadioSelected forState:UIControlStateNormal];
                            objRadioView.selectedIndex = 1;
                            break;
                        case 1:
                            [objRadioView.btnOption2 setImage:imgRadioSelected forState:UIControlStateNormal];
                            objRadioView.selectedIndex = 2;
                            break;
                        case 2:
                            [objRadioView.btnOption3 setImage:imgRadioSelected forState:UIControlStateNormal];
                            objRadioView.selectedIndex = 3;
                            break;
                        case 3:
                            [objRadioView.btnOption4 setImage:imgRadioSelected forState:UIControlStateNormal];
                            objRadioView.selectedIndex = 4;
                            break;
                        case 4:
                            [objRadioView.btnOption5 setImage:imgRadioSelected forState:UIControlStateNormal];
                            objRadioView.selectedIndex = 5;
                            break;
                    }
                
                UIImageView *ansImage =  nil;
                UIButton *bnFeedback = nil;
                
                switch (objRadioView.selectedIndex) {
                    case 1:
                        ansImage =  objRadioView.ansImage1;
                        bnFeedback = objRadioView.btnFeedback1;
                        break;
                    case 2:
                        ansImage =  objRadioView.ansImage2;
                        bnFeedback = objRadioView.btnFeedback2;
                        break;
                    case 3:
                        ansImage =  objRadioView.ansImage3;
                        bnFeedback = objRadioView.btnFeedback3;
                        break;
                    case 4:
                        ansImage =  objRadioView.ansImage4;
                        bnFeedback = objRadioView.btnFeedback4;
                        break;
                    case 5:
                        ansImage =  objRadioView.ansImage5;
                        bnFeedback = objRadioView.btnFeedback5;
                        break;
                }
                
                
                [ansImage setImage:imgAnswerTrue];
                
                NSString *feeback = [self fn_getFeeback:objDRAGDROP.arrFeedback AndCorrect:@"correct" Andfeed:objRadioView.selectedIndex];
                if (feeback.length > 0) {
                    bnFeedback.hidden = NO;
                    objRadioView.feedback = feeback;
                }
                
                if(objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15){
                    bnFeedback.hidden = YES;
                }

                
            }
            //
        
        }
        //
    }

    
    [self disableEditFields];
}
//---------------------------------------------------------


# pragma mark - Button Actions
//---------------------------------------------------------
-(void)Fn_Feedback_Tapped:(id)sender
{
    objRadioView = [arr_radioButtons objectAtIndex:[sender tag]];
    
    UIButton *bn = (UIButton *)sender;
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point =bn.frame.origin.x-60;
        y_point =bn.frame.origin.y + bn.superview.frame.origin.y+48;// + 130;
        
        if(objDRAGDROP.intDRAGDROPRADIOid == 26)
        {
            x_point=x_point-15;
        }
        
        if(objDRAGDROP.intDRAGDROPRADIOid == 18)
        {
            x_point=x_point+15;
        }
        
        if(objDRAGDROP.intDRAGDROPRADIOid == 9)
        {
            x_point=x_point+10;
        }
        
        y_point=y_point-visibleRect.origin.y;
    }
    else
    {
        x_point =  imgScroller.frame.origin.x + bn.frame.origin.x + bn.superview.frame.origin.x - (225);
        y_point =  imgScroller.frame.origin.y + bn.frame.origin.y + bn.superview.frame.origin.y - (131);
        y_point = y_point - visibleRect.origin.y;
        
        x_feedback_l = bn.frame.origin.x + bn.superview.frame.origin.x - (225) ;
        y_feedback_l = bn.frame.origin.y + bn.superview.frame.origin.y - (131);
    }
    
    [self Fn_AddFeedbackPopup:x_point andy:y_point andText:objRadioView.feedback];
}
-(IBAction)onFeedbackTapped2:(id)sender
{
    UIButton *btn = sender;
    CustomDragButton *bn = [draggableSubjectsCopy objectAtIndex:btn.tag];
    
    NSLog(@" Feedback: %@",bn.strFeedback);
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 157);
        
        y_point = bn.superview.frame.origin.y + 85;
        y_point = y_point - visibleRect.origin.y-20;
        
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
-(IBAction)onFeedbackTapped3:(id)sender
{
    CustomDragButton *bn = sender;
    
    float x_point;
    float y_point;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        x_point = bn.frame.origin.x + bn.superview.frame.origin.x + (objDRAGDROP.fWidth - 157);
        y_point = bn.superview.frame.origin.y+55;
        y_point = y_point - visibleRect.origin.y-5;
        
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
-(void)Fn_Radio_Tapped:(id)sender
{
    
    objRadioView = [arr_radioButtons objectAtIndex:[sender tag]];
    
    [objRadioView.btnOption1 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption2 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption3 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption4 setImage:imgRadio forState:UIControlStateNormal];
    [objRadioView.btnOption5 setImage:imgRadio forState:UIControlStateNormal];
    
    [sender setImage:imgRadioSelected forState:UIControlStateNormal];
    
    if (sender == objRadioView.btnOption1) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:0];
        if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
            NSArray *temp = [[objDRAGDROP.arrRadioOptions objectAtIndex:[sender tag]] componentsSeparatedByString:@","];
            objRadioView.selected = [temp objectAtIndex:0];
        }
        objRadioView.selectedIndex = 1;
    }
    else if (sender == objRadioView.btnOption2) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:1];
        if (objDRAGDROP.intDRAGDROPRADIOid == 14 || objDRAGDROP.intDRAGDROPRADIOid == 15) {
            NSArray *temp = [[objDRAGDROP.arrRadioOptions objectAtIndex:[sender tag]] componentsSeparatedByString:@","];
            objRadioView.selected = [temp objectAtIndex:1];
        }
        objRadioView.selectedIndex = 2;
    }
    else if (sender == objRadioView.btnOption3) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:2];
        objRadioView.selectedIndex = 3;
    }
    else if (sender == objRadioView.btnOption4) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:3];
        objRadioView.selectedIndex = 4;
    }
    else if (sender == objRadioView.btnOption5) {
        objRadioView.selected = [objDRAGDROP.arrRadioOptions objectAtIndex:4];
        objRadioView.selectedIndex = 5;
    }
}
//---------------------------------------------------------


#pragma mark - AlertView
//---------------------------------------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
            [self handleShowAnswers];
        }
    }
}
//---------------------------------------------------------


#pragma mark - scrollview delegate
//---------------------------------------------------------
-(void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    feedbackView.hidden=YES;
    visibleRect.origin = aScrollView.contentOffset;
}
//---------------------------------------------------------


#pragma mark - Gesture
//---------------------------------------------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[CustomDragButton class]])
        return YES;
    return NO;
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
    [imgScroller setFrame:CGRectMake(20, 370, 750, 360)];
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
    [imgScroller setFrame:CGRectMake(258, 153, 800, 427)];
    imgScroller.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, imgScroller.bounds.size.width - 727);
    //[scrollViewDrag setFrame:CGRectMake(0, 153, 237, 427)];
    [scrollViewDrag setFrame:CGRectMake(20, 153, 237, 427)];
    
    [self rotateScrollViewButtonsForLandscape];
}
//---------------------------------------------------------
@end
