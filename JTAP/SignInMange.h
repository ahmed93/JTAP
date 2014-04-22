//
//  SignInMange.h
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/5/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ServerManager;
@class TutorialManagerVC;
@class Reachability;
@class Authenticated_User;
@class GradientButton;

@interface SignInMange : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    //TutorialManagerVC *TutorialVC;
    
    UIAlertView *al;
    NSString *username ;
    NSString *password ;
    NSString *access_Token ;
    
    ServerManager *server;
    Reachability* hostReach;
    Authenticated_User *AUser;

}

@property (retain, nonatomic) IBOutlet UITextField *userTextF;
@property (retain, nonatomic) IBOutlet UITextField *passTextF;
@property (retain, nonatomic) IBOutlet GradientButton *signInB;
@property (retain, nonatomic) IBOutlet UISwitch *autoLogInSwitch;


- (IBAction)setLogInCheck:(id)sender;

@end
