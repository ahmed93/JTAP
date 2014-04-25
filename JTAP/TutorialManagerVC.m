//
//  TutorialManagerVC.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/27/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "TutorialManagerVC.h"
#import "SignInMange.h"
#import "Reachability.h"
#import "ServerManager.h"
#import "Authenticated_User.h"
#import "Groups.h"
#import "StudentsManager.h"


@interface TutorialManagerVC ()
{
    NSMutableArray* MAINTABLE;
}

@end

@implementation TutorialManagerVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////
//  Table View Configrations    //
//////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    MAINTABLE = [[NSMutableArray alloc]init];
    [self GetDataAtEntry];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableControler) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:refreshControl];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [MAINTABLE count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = [[MAINTABLE objectAtIndex:[indexPath row]] Group_Name];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSLog(@"     %@",cellText);
    
    [self performSegueWithIdentifier:@"detailsV" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailsV"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%@",[MAINTABLE objectAtIndex:[indexPath row]]);
        NSString *object = [[MAINTABLE objectAtIndex:[indexPath row]] Group_ID];
        NSLog(@"%@",object);
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"group_ID"];
        [[segue destinationViewController] setGroupID:object];
    }
}


///////////////////////////////
//  Network Configrations    //
///////////////////////////////

-(void)GetDataAtEntry
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
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
                NSDictionary *allData = [[server getGroups] autorelease];
                
                NSMutableArray* group_Name = [NSMutableArray arrayWithArray:[allData valueForKey:@"code"]];
                NSMutableArray* group_ID= [NSMutableArray arrayWithArray:[allData valueForKey:@"id"]];
                
                for (NSString* value in group_Name) {
                    Groups* newGroup = [[Groups alloc]init:value :[group_ID objectAtIndex:[group_Name indexOfObject:value]]];
                    [MAINTABLE insertObject:newGroup atIndex:[group_Name indexOfObject:value]];
                    
                }

                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
            });
            break;
        }
    }
}

/////////////////////////////
//  Other Configrations    //
/////////////////////////////

- (IBAction)DoLogOut:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"autoLog"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)refreshTableControler
{
    [MAINTABLE removeAllObjects];
    [self.tableView reloadData];
    [self GetDataAtEntry];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
