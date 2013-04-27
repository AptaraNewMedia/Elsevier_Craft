//
//  AboutUsViewController.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 21/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

- (void) Fn_LoadAboutData:(int)index;

@end
