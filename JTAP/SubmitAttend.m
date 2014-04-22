//
//  SubmitAttend.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 2/8/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "SubmitAttend.h"	
#import "Reachability.h"
#import "ServerManager.h"
#import "GradientButton.h"
#import <UIKit/UIKit.h>



@interface SubmitAttend (){

    NSString* SLOT;
    NSString* LOCATION;
    NSString* DATE;
    NSString* GROUP_ID;
    NSMutableArray* STUDENTS_IDS;
    NSString*ERROR;
    UIActionSheet *secondView;
    UIDatePicker *theDatePicker;
    UITextField* SlotSV;
    GradientButton* DoneSV;
}

@end

@implementation SubmitAttend

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
    [self initSecondView];
    
    self.taName.text= [[NSUserDefaults standardUserDefaults]stringForKey:@"TA_name"];
    [self.DoneB useWhiteStyle];
    [self.BackB useWhiteStyle];
    [self.EditToSecondVB useWhiteStyle];
    
    self.Slote.text = [NSString stringWithFormat:@"0"];
    self.CurrentDate.text =[self updateCurrentDate:[NSDate date]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *EditBGR = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showEditDate)];
    
    [self.EditToSecondVB addGestureRecognizer:EditBGR];
    
    UITapGestureRecognizer *CancelTakingA = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(GetBack)];
    
    [self.BackB addGestureRecognizer:CancelTakingA];
    
    UITapGestureRecognizer *DoneTakingA = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(DoneTaking)];
    
    [self.DoneB addGestureRecognizer:DoneTakingA];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.BackB.enabled  = YES;
    
    NSMutableArray* students_array = [[NSUserDefaults standardUserDefaults] valueForKey:@"students_ids"];
   
    self.totalStudents.text = [NSString stringWithFormat:@"%i" , [students_array count]];
    
}

-(void)dismissKeyboard {
    [SlotSV resignFirstResponder];
    [self.LocationTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_CurrentDate release];
    [_Slote release];
    [_LocationTF release];
    [_DoneB release];
    [_BackB release];
    [_EditToSecondVB release];
    [_totalStudents release];
    [_taName release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCurrentDate:nil];
    [self setSlote:nil];
    [self setLocationTF:nil];
    [self setDoneB:nil];
    [self setBackB:nil];
    [self setEditToSecondVB:nil];
    [self setTotalStudents:nil];
    [super viewDidUnload];
}

-(void)initSecondView
{
    secondView = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 35.0, 0.0, 0.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    [theDatePicker.layer setOpacity:0.9];
    
    
    DoneSV = [[GradientButton alloc] initWithFrame:CGRectMake(20.0, 255.0, 280, 28.0)];
    [DoneSV useWhiteStyle];
    [DoneSV setTitle:@"Done" forState:UIControlStateNormal];
    DoneSV.titleLabel.font = [UIFont fontWithName:@"Palatino" size:13.0];
    DoneSV.tintColor = [UIColor blackColor];
    if (DoneSV.isSelected) {
        [secondView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    
    SlotSV = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 3, 280.0, 30.0)];
    SlotSV.backgroundColor = [UIColor whiteColor];
    SlotSV.placeholder = @"Enter Slot Number";
    SlotSV.keyboardType = UIKeyboardTypeNumberPad;
    SlotSV.borderStyle = UITextBorderStyleRoundedRect;
    SlotSV.font = [UIFont fontWithName:@"Palatino" size:13.0];
    SlotSV.textAlignment = NSTextAlignmentCenter;
    SlotSV.delegate = secondView.delegate;
    SlotSV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    SlotSV.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    SlotSV.returnKeyType = UIReturnKeyDone;
    SlotSV.adjustsFontSizeToFitWidth = YES;
    SlotSV.userInteractionEnabled = TRUE;
    
    
    
    
    [secondView addSubview:theDatePicker];
    [secondView addSubview:DoneSV];
    [secondView addSubview:SlotSV];
    [secondView setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *DoneSVGesture = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissSecondView)];
    
    [DoneSV addGestureRecognizer:DoneSVGesture];
    
    UITapGestureRecognizer *SlotSVDiss = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissKeyboard)];
    [secondView addGestureRecognizer:SlotSVDiss];
}

-(void)dismissSecondView
{
    [secondView dismissWithClickedButtonIndex:0 animated:YES];
    self.CurrentDate.text = [self updateCurrentDate:theDatePicker.date];
}

- (void)showEditDate
{    
    [secondView showInView:self.view];
    [secondView setBounds:CGRectMake(0,0,320, 560)];
}

- (void)GetBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)DoneTaking
{
    LOCATION = self.LocationTF.text;
    DATE = self.CurrentDate.text;
    GROUP_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"group_ID"];
    STUDENTS_IDS = [[NSUserDefaults standardUserDefaults] valueForKey:@"students_ids"];
    SLOT = @"2";
    
    if ([LOCATION isEqual:@""]) {
        UIAlertView* al = [[[UIAlertView alloc] initWithTitle:nil message:@"Location can not be empty" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil] autorelease];
        [al show];
    }else{
        [self GetDataAtEntry];
    }
    
}


-(void)GetDataAtEntry
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self checkNetworkStatus: hostReach];
        });
    });
}

-(void) checkNetworkStatus:(Reachability*)curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"not asscessable");
            UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check your Wi-Fi or 3G" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
            [noConnention show];
            
            break;
        }
            
        default:
        {
            NSLog(@"asscessable");
            self.view.userInteractionEnabled = NO;
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                server = [[[ServerManager alloc]init]autorelease];
                //:(NSString*)group_ID :(NSMutableArray *)ids :(NSString *) location :(NSString *) slot :(NSString*)date
                NSDictionary* alldata = [server createSession:GROUP_ID:STUDENTS_IDS :LOCATION  :SLOT :DATE];
                
                NSLog(@"%@",alldata);
                
                if ([alldata valueForKey:@"errors"]!=NULL || alldata == NULL) {
                    ERROR = @"YES";
                }
                
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    if ([ERROR isEqual:@"YES"]) {
                        self.view.userInteractionEnabled = YES;
                        UIAlertView *noConnention = [[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"could not sync please try again.." delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil, nil]autorelease];
                        [noConnention show];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    
                });
            });
            break;
        }
    }
}



-(NSString*)updateCurrentDate:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    return [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
}
-(NSString*)updateCurrentSlot:(NSString*)newSlot
{
    return [NSString stringWithFormat:@"%@",newSlot];
}

@end
