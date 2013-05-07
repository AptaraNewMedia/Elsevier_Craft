//
//  CustomPopViewController.m
//  PathoPhys
//
//  Created by Admin on 4/22/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "NotesPopViewController.h"

@interface NotesPopViewController ()


-(IBAction)Bn_AddNote_Tapped:(id)sender;
-(IBAction)Bn_ViewNote_Tapped:(id)sender;

@end

@implementation NotesPopViewController
@synthesize Bn_Addnote;
@synthesize viewPopup;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor clearColor];

    [Bn_Addnote setTitleColor:COLOR_BottomGrayButton forState:UIControlStateNormal];
    [Bn_Addnote setTitleColor:COLOR_BottomBlueButton forState:UIControlStateHighlighted];

    [Bn_ViewNote setTitleColor:COLOR_BottomGrayButton forState:UIControlStateNormal];
    [Bn_ViewNote setTitleColor:COLOR_BottomBlueButton forState:UIControlStateHighlighted];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.view.frame=CGRectMake(00, 44, 320, 392);
        [viewPopup setFrame:CGRectMake(201, -12, 86, 65)];
        Bn_BGButton.frame=CGRectMake(00, 00, 320, 392);
        
        Bn_Addnote.titleLabel.font=FONT_10;
        Bn_ViewNote.titleLabel.font=FONT_10;
    }
    else
    {
        Bn_Addnote.titleLabel.font=FONT_14;
        Bn_ViewNote.titleLabel.font=FONT_14;
    }
    

}

-(IBAction)Bn_BGButton_Tapped:(id)sender
{
    [self.view removeFromSuperview];
}

-(IBAction)Bn_AddNote_Tapped:(id)sender
{
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view removeFromSuperview];
    [md Fn_ShowNote:[sender tag]];
}

-(IBAction)Bn_ViewNote_Tapped:(id)sender
{
    
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view removeFromSuperview];
    [md Fn_AddNotesList];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    }
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

-(void)Fn_rotateLandscape
{
//    [Bn_BGButton setFrame:CGRectMake(0, 0, 1024, 680)];
//    [Bn_Addnote setFrame:CGRectMake(834, 29, 132, 31)];
//    [Bn_ViewNote setFrame:CGRectMake(834, 72, 132, 31)];
//    [Img_NotePopup setFrame:CGRectMake(812, 0, 169, 120)];
//    [Img_Seperator1 setFrame:CGRectMake(852, 61, 95, 3)];

    self.view.frame=CGRectMake(00, 44, 1024, 680);
    [Bn_BGButton setFrame:CGRectMake(0, 0, 1024, 680)] ;
    [viewPopup setFrame:CGRectMake(761, -15, 230, 140)];
}

-(void)Fn_rotatePortrait
{
//    [Bn_BGButton setFrame:CGRectMake(0, 0, 768, 936)];
//    [Bn_Addnote setFrame:CGRectMake(574, 29, 132, 31)];
//    [Bn_ViewNote setFrame:CGRectMake(574, 72, 132, 31)];
//    [Img_NotePopup setFrame:CGRectMake(552, 0, 169, 120)];
//    [Img_Seperator1 setFrame:CGRectMake(592, 61, 95, 3)];

    self.view.frame=CGRectMake(00, 44, 768, 936);
    [Bn_BGButton setFrame:CGRectMake(0, 0, 768, 936)];    
    [viewPopup setFrame:CGRectMake(501, -15, 230, 140)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
