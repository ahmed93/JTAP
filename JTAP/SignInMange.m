//
//  SignInMange.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/5/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "SignInMange.h"
#import "Reachability.h"
#import "ServerManager.h"
#import "Authenticated_User.h"
#import "TutorialManagerVC.h"
#import "GradientButton.h"


#import <QuartzCore/QuartzCore.h>


@interface SignInMange ()
{
    UIView *shadow,*alertCustomView;
}

@end

@implementation SignInMange 

@synthesize passTextF,userTextF,signInB,autoLogInSwitch;

- (void)dealloc
{
    [userTextF release];
    [passTextF release];
    [signInB release];
    [autoLogInSwitch release];
    [shadow release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setUserTextF:nil];
    [self setPassTextF:nil];
    [self setAutoLogInSwitch:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////
//  UIView Configrations    //
//////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [signInB useWhiteStyle];
    [userTextF setLeftViewMode:UITextFieldViewModeAlways];
    [passTextF setLeftViewMode:UITextFieldViewModeAlways];

    userTextF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-user.png"]];
    passTextF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock.png"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    UITapGestureRecognizer *tbutton =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ButtonClicked)];
    
    [self.view addGestureRecognizer:tap];
    [signInB addGestureRecognizer:tbutton];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString * autoLog =[[NSUserDefaults standardUserDefaults] valueForKey:@"autoLog"];
    
    if ([autoLog isEqual:@"false"]) {

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLog"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *_username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"] ;
    NSString *_password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"] ;
    
    NSString *_access_Token = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"] ;
    
    if (_username==NULL || _password ==NULL || _access_Token == NULL) {
        userTextF = self.userTextF;
        passTextF = self.passTextF;
        signInB = self.signInB;
        AUser = NULL;
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLog"];
        autoLogInSwitch = self.autoLogInSwitch;
        
        [autoLogInSwitch setOn:NO];
        
        self.userTextF.text = @"";
        self.passTextF.text = @"";
        
    }else{
        username =  userTextF.text;
        password = passTextF.text;
        [self checkForAutoLogIn];
    }
}

/////////////////////////////////
//  TextField Configrations    //
/////////////////////////////////

-(void)dismissKeyboard
{
    [userTextF resignFirstResponder];
    [passTextF resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userTextF) {
        [passTextF becomeFirstResponder];
    } else {
        [self dismissKeyboard];
    }
    return YES;
}

///////////////////////////////
//  Network Configrations    //
///////////////////////////////

-(void)GetDataAtEntry
{
    [self dismissKeyboard];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
        dispatch_async( dispatch_get_main_queue(), ^{
            [hostReach startNotifier];
            [self startShadowedView];
            [self checkNetworkStatus: hostReach];
        });
    });
    
}

- (void) checkNetworkStatus:(Reachability*)curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"not asscessable");
            
            UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check your Wi-Fi or 3G" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
            [shadow removeFromSuperview];
            [noConnention show];
            break;
        }
            
        default:
        {
            NSLog(@"asscessable");
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                server = [[[ServerManager alloc]init]autorelease];
                NSDictionary *authCheck = [[server AuthenticatedUsers:self.userTextF.text :self.passTextF.text] autorelease];
                
                if ([authCheck valueForKey:@"errors"]==NULL) {
                    AUser = [[Authenticated_User alloc]init:[authCheck valueForKey:@"username"] :passTextF.text :[authCheck valueForKey:@"access_token"] :[authCheck valueForKey:@"uid"] :[authCheck valueForKey:@"name"]];
                }
                 
                dispatch_async( dispatch_get_main_queue(), ^{
                    if (AUser==NULL) {

                        al = [[[UIAlertView alloc]initWithTitle:nil message:@"Wrong username or password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
                        [al show];
                        
                    } else {
                        
                        //** Add user to database **\\
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[AUser username] forKey:@"username"];
                        [[NSUserDefaults standardUserDefaults] setObject:[AUser password] forKey:@"password"];
                        [[NSUserDefaults standardUserDefaults] setObject:[AUser access_token] forKey:@"accessToken"];
                        [[NSUserDefaults standardUserDefaults] setObject:[AUser name] forKey:@"TA_name"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self performSegueWithIdentifier:@"LogV" sender:self];
                    }
                    [shadow removeFromSuperview];
                });
            });
            break;
        }
    }
    
    autoLogInSwitch.enabled = YES;
}


/////////////////////////////
//  Other Configrations    //
/////////////////////////////


-(IBAction)setLogInCheck:(id)sender
{
    if ([autoLogInSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"ture" forKey:@"autoLog"];
        
        NSLog(@"AutoLogIn: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"autoLog"]);
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"false"  forKey:@"autoLog"];
        NSLog(@"AutoLogIn: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"autoLog"]);
    }
}

-(void)ButtonClicked
{
    [self dismissKeyboard];
    
    username = userTextF.text;
    password = passTextF.text;
    if(![username isEqual:@""] && ![password isEqual:@""]){
        NSLog(@"username and password are empty");
        [self GetDataAtEntry];
    }else if ([username isEqual:@""] && ![password isEqual:@""]) {
        UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:nil message:@"Enter username" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
        [noConnention show];
        
        NSLog(@"username is empty");
    } else if([password isEqual:@""] && ![username isEqual:@""]){
        UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:nil message:@"Enter password" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
        [noConnention show];
        
        NSLog(@"password is empty");
    }else if([password isEqual:@""] &&  [username isEqual:@""]){
        UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:nil message:@"Enter username and password" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
        [noConnention show];
        NSLog(@"username and password are empty");
    }
    
}

-(BOOL)coreDataHasEntriesForEntityName
{


    NSString *_username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"] ;
    NSString *_password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"] ;
    NSString *_access_Token = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"] ;
    
    if (_username==NULL || _password ==NULL || _access_Token == NULL) {
        return NO;
    }
    return YES;
}

-(void)checkForAutoLogIn
{
    if ([self coreDataHasEntriesForEntityName]) {

        username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        userTextF.text = username;
        passTextF.text = password;
        
        [self GetDataAtEntry];
    }
}

-(void)startShadowedView
{
    if (shadow == nil) {
        shadow = [[UIView alloc]initWithFrame:self.view.frame];
        shadow.frame = CGRectMake(0.0,0.0, self.view.frame.size.width, self.view.frame.size.height);
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0.3f;
        
//        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [loading startAnimating];
//        loading.frame = CGRectMake(shadow.frame.size.width/2.0, (shadow.frame.size.height+100)/2.0, 0.0, 0.0);
//        [shadow addSubview:loading];
    }
    [self.view addSubview:shadow];
}

//-(void)customAlertView
//{
//    if (alertCustomView == nil) {
//        alertCustomView = [[UIView alloc]initWithFrame:self.view.frame];
//        int alertCustomView_width = 290.0f;
//        int alertCustomView_hight = 150.0f;
//        [alertCustomView.layer setCornerRadius:20.0f];
//        [alertCustomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [alertCustomView.layer setBorderWidth:1.5];
//        alertCustomView.frame = CGRectMake((self.view.frame.size.width/2.0)-(alertCustomView_width/2.0), (self.view.frame.size.height/2.0)-(alertCustomView_hight/2.0), alertCustomView_width, alertCustomView_hight);
//        alertCustomView.backgroundColor = [UIColor blackColor];
//        alertCustomView.alpha = 0.5f;
//    }
//    [shadow addSubview:alertCustomView];
//}
//-(void)stopShadowView
//{
//    [shadow removeFromSuperview];
//}




@end
