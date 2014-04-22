//
//  StudentsManager.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/30/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "StudentsManager.h"
#import "Reachability.h"
#import "Student.h"
#import "ServerManager.h"
#import "Groups.h"
#import "SubmitAttend.h"

@interface StudentsManager ()
{
    NSMutableArray *_MAINTABLE;
    NSMutableArray * Students_ids;
    UITextField* Location;
    UITextField* Slot;
}

@end

@implementation StudentsManager

@synthesize groupID,SubmitionB;

-(void)dealloc
{
    [_MAINTABLE release];
    [SubmitionB release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"T_%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"group_ID"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_MAINTABLE count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = [[_MAINTABLE objectAtIndex:[indexPath row]] name];
    cell.detailTextLabel.text = [[_MAINTABLE objectAtIndex:[indexPath row]] uid];
    cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino" size:13];

    return cell;
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

- (void) checkNetworkStatus:(Reachability*)curReach
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
            
            [self.tableView reloadData];
            
            
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                server = [[[ServerManager alloc]init]autorelease];
                NSDictionary *allData = [[server getList:groupID] autorelease];
                
                NSMutableArray* Student_Name = [NSMutableArray arrayWithArray:[[allData valueForKey:@"students"] valueForKey:@"name"]];
                NSMutableArray* Student_uid = [NSMutableArray arrayWithArray:[[allData valueForKey:@"students"] valueForKey:@"uid"]];
                NSMutableArray* Student_id = [NSMutableArray arrayWithArray:[[allData valueForKey:@"students"] valueForKey:@"id"]];
                NSMutableArray* group_Name= [[NSMutableArray arrayWithArray:[[allData valueForKey:@"students"] valueForKey:@"group"]] valueForKey:@"code"];
                NSMutableArray* group_ID= [[NSMutableArray arrayWithArray:[[allData valueForKey:@"students"] valueForKey:@"group"]] valueForKey:@"id"];
                
                for (NSString* value in Student_id) {
                    int index = [Student_id indexOfObject:value];
                    Groups* newGroup = [[[Groups alloc]init:[group_Name objectAtIndex:index] :[group_ID objectAtIndex:index]]autorelease];
                    Student* newstudent = [[[Student alloc]init:value :[Student_Name objectAtIndex:index] :[Student_uid objectAtIndex:index] :newGroup]autorelease];
                    
                    [_MAINTABLE insertObject:newstudent atIndex:index];
                }
                  
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
            });
            break;
        }
    }
}

-(void)setGroupID:(NSString *)group_ID
{
    groupID = group_ID;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSLog(@"%i",[indexPath row]);
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.highlighted = NO;
    NSLog(@"%@",Students_ids);
    if(selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [Students_ids addObject:[[_MAINTABLE objectAtIndex:[indexPath row]] _ID]];
    }
    else
    {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [Students_ids removeObject:[[_MAINTABLE objectAtIndex:[indexPath row]] _ID]];
    }
    
    NSLog(@"%@",Students_ids);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        Students_ids = [[NSMutableArray alloc]init];
     _MAINTABLE = [[NSMutableArray alloc]init];
    [_MAINTABLE removeAllObjects];
    [self.tableView reloadData];
    [self GetDataAtEntry];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:Students_ids forKey:@"students_ids"];
    NSLog(@"added");
}



- (void)viewDidUnload {
    [self setSubmitionB:nil];
    [super viewDidUnload];
}

@end
