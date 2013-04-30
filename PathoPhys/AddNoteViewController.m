//
//  ScoreViewController.m
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Notes.h"

@interface AddNoteViewController ()
{
    
    IBOutlet UIImageView *imgBG;
    IBOutlet UIButton *btnClose;
    
    IBOutlet UILabel *lblCnameHolder;
    IBOutlet UILabel *lblChapterName;
    IBOutlet UILabel *lblThematicName;
    

    IBOutlet UILabel *ChapterName;
    IBOutlet UILabel *ThematicName;
    IBOutlet UILabel *lblInstruction;
    
    IBOutlet UITextView *txtNote;
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnClear;
    
    Notes *objNotes;
    NSString *strNoteInstruction;
}
@end

@implementation AddNoteViewController
@synthesize lblTitle;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // Do any additional setup after loading the view from its nib.
    [self Fn_SetFontColor];
    
    strNoteInstruction = @"Please enter note here.";
    
    switch (objNotes.intCategoryId) {
        case 1:
            lblChapterName.text = strCurrentChapterName;
            ThematicName.hidden = YES;
            lblThematicName.hidden = YES;
            break;
        case 2:
            lblChapterName.text = strCurrentChapterName;
            lblThematicName.text = strCurrentThematicName;
            break;
        case 3:
            lblChapterName.text = strCurrentChapterName;
            lblThematicName.text = strCurrentThematicName;
            break;
    }
    
    lblChapterName.text = objNotes.strNoteTitle;
    
    if (objNotes.intMode == 2) {
        txtNote.text = objNotes.strNoteDesc;
    }
    else {
        txtNote.text = strNoteInstruction;
    }
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }

}


-(void) Fn_SetFontColor
{
    lblChapterName.textColor = COLOR_BottomBlueButton;
    lblChapterName.font = FONT_17;
    
    txtNote.font = FONT_17;
    txtNote.textColor = COLOR_BottomGrayButton;
    
    lblTitle.font = FONT_20;
    lblTitle.textColor = COLOR_WHITE;
}

- (void) Fn_LoadNoteData:(Notes *)notes
{
    objNotes = notes;
}

-(IBAction)onClose:(id)sender
{
    [md Fn_SubAddNote];
}

-(IBAction)onSave:(id)sender
{
    if (txtNote.text.length > 0) {
        objNotes.strNoteDesc = txtNote.text;        
        if (objNotes.intMode == 1) {
            objNotes.strCreatedDate = md.strCurrentDate;
            objNotes.strModifiedDate = md.strCurrentDate;
            objNotes.intMode = 2;
            [db fnSetNote:objNotes];
        }
        else {
            objNotes.strModifiedDate = md.strCurrentDate;
            [db fnUpdateNote:objNotes];
        }        
        
        NOTES_MODE = 2;        
        [md Fn_SubAddNote];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Message"];
        [alert setDelegate:self];
        [alert setTag:1];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:[NSString stringWithFormat:@"Please enter text."]];
        [alert show];

    }
}

-(IBAction)onClear:(id)sender
{
    txtNote.text = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
	}
	else {
        [self Fn_rotatePortrait];
	}
    
	return YES;
}

-(void)Fn_rotatePortrait
{
    [self.view setFrame:CGRectMake(0,0,768,1024)];
    
    [imgBG setImage:[UIImage imageNamed:@"P_note_BG_01.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 768, 1024)];
    [lblTitle setFrame:CGRectMake(46,134,683,36)];
    [btnClose setFrame:CGRectMake(650,130,41,36)];
    [lblChapterName setFrame:CGRectMake(200,200,470,38)];
    //[ChapterName setFrame:CGRectMake(100,210,156,21)];
    //[lblInstruction setFrame:CGRectMake(110,350,188,21)];
    [txtNote setFrame:CGRectMake(106, 320 ,582 ,390)];
    [btnSave setFrame:CGRectMake( 560,770,100,33)];
    [btnClear setFrame:CGRectMake( 430,770,100,33)];
    [lblCnameHolder setFrame:CGRectMake(140, 208, 50, 21)];
}
-(void)Fn_rotateLandscape
{
    [self.view setFrame:CGRectMake(0,0,1024,768)];
    
    [imgBG setImage:[UIImage imageNamed:@"L_Note_BG_01.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 1024, 768)];
    [lblTitle setFrame:CGRectMake(186,104,683,36)];
    [btnClose setFrame:CGRectMake(833,114,41,36)];
    [lblChapterName setFrame:CGRectMake(223,160,637,38)];
    //[ChapterName setFrame:CGRectMake(150,170,156,21)];
    //[lblInstruction setFrame:CGRectMake(200,296,188,21)];
    [txtNote setFrame:CGRectMake(171, 245 ,682 ,282)];
    [btnSave setFrame:CGRectMake(760,564,100,33)];
    [btnClear setFrame:CGRectMake(638,564,100,33)];
    
    [lblCnameHolder setFrame:CGRectMake(171, 168, 50, 21)];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{    
    if ([strNoteInstruction isEqualToString:txtNote.text]) {
        txtNote.text = @"";
    }
    
    return YES;
}

@end
