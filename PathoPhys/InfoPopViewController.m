//
//  InfoPopViewController.m
//  PathoPhys
//
//  Created by Admin on 4/22/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "InfoPopViewController.h"

@interface InfoPopViewController ()

@end

@implementation InfoPopViewController
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
    
    [Bn_AboutAuthor setTitleColor:COLOR_BottomGrayButton forState:UIControlStateNormal];
    [Bn_AboutAuthor setTitleColor:COLOR_BottomBlueButton forState:UIControlStateHighlighted];
    Bn_AboutAuthor.titleLabel.font=FONT_12;
    
    
    [Bn_AboutApp setTitleColor:COLOR_BottomGrayButton forState:UIControlStateNormal];
    [Bn_AboutApp setTitleColor:COLOR_BottomBlueButton forState:UIControlStateHighlighted];
    Bn_AboutApp.titleLabel.font=FONT_12;
    
    
    [Bn_ElsevierAustralia setTitleColor:COLOR_BottomGrayButton forState:UIControlStateNormal];
    [Bn_ElsevierAustralia setTitleColor:COLOR_BottomBlueButton forState:UIControlStateHighlighted];
    Bn_ElsevierAustralia.titleLabel.font=FONT_12;
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

-(IBAction)Bn_BGButton_Tapped:(id)sender
{
    [self.view removeFromSuperview];
}

-(IBAction)Bn_AboutTheAuthor_Tapped:(id)sender
{
    [self.view removeFromSuperview];
    [md Fn_AddAbout:0];
}

-(IBAction)Bn_AboutTheApp_Tapped:(id)sender
{
    [self.view removeFromSuperview];
    [md Fn_AddAbout:1];
}

-(IBAction)Bn_AboutElsevierAustrelia_Tapped:(id)sender
{
    [self.view removeFromSuperview];
    [md Fn_AddAbout:2];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
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

-(void)Fn_rotateLandscape
{
//    [Bn_BGButton setFrame:CGRectMake(0, 0, 1024, 680)];
//    [Bn_AboutAuthor setFrame:CGRectMake(873, 16, 132, 31)];
//    [Bn_AboutApp setFrame:CGRectMake(874, 46, 132, 31)];
//    [Bn_ElsevierAustralia setFrame:CGRectMake(874, 76, 132, 31)];
//    [Img_InfoPopup setFrame:CGRectMake(852, 0, 169, 120)];
//    [Img_Seperator1 setFrame:CGRectMake(892, 48, 95, 3)];
//    [Img_Seperator2 setFrame:CGRectMake(892, 76, 95, 3)];
//    self.view.frame=CGRectMake(00, 44, 1024, 680);

    self.view.frame=CGRectMake(00, 44, 1024, 680);
    [Bn_BGButton setFrame:CGRectMake(0, 0, 1024, 680)];
    [viewPopup setFrame:CGRectMake(852, -2, 169, 120)];
}

-(void)Fn_rotatePortrait
{
//    [Bn_BGButton setFrame:CGRectMake(0, 0, 768, 936)];
//    [Bn_AboutAuthor setFrame:CGRectMake(614, 16, 132, 31)];
//    [Bn_AboutApp setFrame:CGRectMake(614, 46, 132, 31)];
//    [Bn_ElsevierAustralia setFrame:CGRectMake(614, 76, 132, 31)];
//    [Img_InfoPopup setFrame:CGRectMake(592, 0, 169, 120)];
//    [Img_Seperator1 setFrame:CGRectMake(632, 48, 95, 3)];
//    [Img_Seperator2 setFrame:CGRectMake(632, 76, 95, 3)];
//    self.view.frame=CGRectMake(00, 44, 768, 936);
    
    self.view.frame=CGRectMake(00, 44, 768, 936);
    [Bn_BGButton setFrame:CGRectMake(0, 0, 768, 936)];    
    [viewPopup setFrame:CGRectMake(592, -2, 169, 120)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
