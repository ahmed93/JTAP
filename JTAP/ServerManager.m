//
//  ServerManager.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 12/22/12.
//  Copyright (c) 2012 Ahmed Mohamed Fareed. All rights reserved.
//

#import "ServerManager.h"
#import "SBJson.h"
#import "AppDelegate.h"


@implementation ServerManager{
     
}

-(NSDictionary*)getGroups
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* Access_Token_Server = [self getAccessToken];
    NSString* url = [NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/groups?access_token=%@", Access_Token_Server];
    //NSString* url = [NSString stringWithFormat:@"http://10.0.0.1:3000/qpbWkDnnC8isQzdMyn6E/groups?access_token=%@", Access_Token_Server];
    NSURL* URL_GROUPS = [NSURL URLWithString:url];
    
    
    NSDictionary* feed = [[[NSDictionary alloc] init] autorelease];
    
    for (int i =0; i<50; i++) {
        NSLog(@"%d",i);
        feed =[self getRequest:URL_GROUPS];
        if (feed != NULL) 
            break;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return feed;
}

-(NSDictionary*)getList :(NSString*)group_ID
{
    NSString* Access_Token_Server = [self getAccessToken];
    NSString* url = [NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/groups/%@/students?access_token=%@",group_ID, Access_Token_Server];
    //NSString* url = [NSString stringWithFormat:@"http://10.0.0.1:3000/qpbWkDnnC8isQzdMyn6E/groups/%@/students?access_token=%@",group_ID, Access_Token_Server];
    NSURL* URL_STUDENTS = [NSURL URLWithString:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary* feed = [[[NSDictionary alloc] init] autorelease];
    
    for (int i =0; i<50; i++) {
        NSLog(@"%d",i);
        feed =[self getRequest:URL_STUDENTS];
        if (feed != NULL)
            break;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return feed;
}

/*
 -(NSDictionary*)getList
 {
 NSString* Access_Token_Server = [self getAccessToken];
 NSString* url = [NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/students?access_token=%@", Access_Token_Server];
 NSURL* URL_STUDENTS = [NSURL URLWithString:url];
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]initWithURL:URL_STUDENTS] autorelease];
 
 NSURLResponse *response;
 NSError *error;
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 NSString *resopnseMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 
 SBJsonParser *jsonPar =[SBJsonParser new];
 id returnvalue = [jsonPar objectWithString:resopnseMsg error:NULL];
 NSDictionary *feed = (NSDictionary *)returnvalue;
 [resopnseMsg release];
 
 NSLog(@"%@",feed);
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 return feed;
 }
 
 */

/*
-(NSDictionary*)deleteStudent:(int)indexPaths
{
    NSURL *urldelete = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/students/%i", indexPaths]];
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc]initWithURL:urldelete] autorelease];
 
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *resopnseMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonPar =[SBJsonParser new];
    id returnvalue = [jsonPar objectWithString:resopnseMsg error:nil];
    NSDictionary *feed = (NSDictionary *)returnvalue;
 
    [resopnseMsg release];
    [data release];
 
    NSLog(@"%@",feed);

    return feed;

}*/

/*-(NSDictionary*)createStudent:(NSString *)StudentName :(NSString *) StudentID
{
   
    NSString *requestBody = [NSString stringWithFormat:@"{\"student\":{\"uid\":\"%@\",\"name\":\"%@\"}}",StudentID,StudentName];
    NSLog(@"........ %@",requestBody);
    NSData *requestData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc]initWithURL:url] autorelease];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setHTTPBody:requestData];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *resopnseMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    SBJsonParser *jsonPar =[SBJsonParser new];
    id returnvalue = [jsonPar objectWithString:resopnseMsg error:nil];
    NSDictionary *feed = (NSDictionary *)returnvalue;

    [resopnseMsg dealloc];
    //NSLog(@"%@",error);
    NSLog(@"%@",feed);

    return feed;
}*/

//{"session":{"slot":"1","location":"c2-133","date":"2012-03-12","student_ids":[18,24]}}

-(NSDictionary*)createSession :(NSString*)group_ID :(NSMutableArray *)ids :(NSString *) location :(NSString *) slot :(NSString*)date
{
    
    NSString* Access_Token_Server = [self getAccessToken];
    NSString* url = [NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/groups/%@/sessions?access_token=%@",group_ID, Access_Token_Server];
    //NSString* url = [NSString stringWithFormat:@"http://10.0.0.1:3000/qpbWkDnnC8isQzdMyn6E/groups/%@/sessions?access_token=%@",group_ID, Access_Token_Server];
    NSURL* URL_SESSION = [NSURL URLWithString:url];
    NSString* STUDENTS_IDS = @"";

    for (NSString* studentid in ids) {
        if (![STUDENTS_IDS isEqual:@""]) {
            STUDENTS_IDS =[NSString stringWithFormat:@"%@,%@",STUDENTS_IDS,studentid];
        } else {
            STUDENTS_IDS = [NSString stringWithFormat:@"%@",studentid];
        }
        
    }
    STUDENTS_IDS =[NSString stringWithFormat:@"[%@]",STUDENTS_IDS];

    NSString *requestBody = [NSString stringWithFormat:@"{\"session\":{\"date\":\"%@\",\"location\":\"%@\",\"slot\":\"%@\",\"student_ids\":%@}}",date,location,slot,STUDENTS_IDS];
    NSLog(@"%@",requestBody);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary* feed = [[[NSDictionary alloc] init] autorelease];
    
    for (int i =0; i<5; i++) {
        NSLog(@"%d",i);
        feed =[self postRequest:requestBody :URL_SESSION];
        if (feed != NULL)
            break;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    return feed;
}

-(NSDictionary*)AuthenticatedUsers:(NSString *)username :(NSString *)password
{    
    NSString* url = [NSString stringWithFormat:@"http://api.ramin0.me/qpbWkDnnC8isQzdMyn6E/auths"];
     //NSString* url = [NSString stringWithFormat:@"http://10.0.0.1:3000/qpbWkDnnC8isQzdMyn6E/auths"];
    NSURL* URL_Auths = [NSURL URLWithString:url];
    
    
    NSString *requestBody = [NSString stringWithFormat:@"{\"auth\":{\"username\":\"%@\",\"password\":\"%@\"}}",username,password];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary* feed = [[[NSDictionary alloc] init] autorelease];
    
    for (int i =0; i<50; i++) {
        NSLog(@"%d",i);
        feed =[self postRequest:requestBody :URL_Auths];
        if (feed != NULL)
            break;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    

    
    return feed;
}

-(NSString*)getAccessToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
}

-(NSDictionary*)postRequest:(NSString *)requestBody :(NSURL *)URL
{
    NSData *requestData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc]initWithURL:URL] autorelease];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *resopnseMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    SBJsonParser *jsonPar =[SBJsonParser new];
    id returnvalue = [jsonPar objectWithString:resopnseMsg error:nil];
    NSDictionary *feed = (NSDictionary *)returnvalue;
    
    [resopnseMsg autorelease];
    //NSLog(@"%@",feed);
    
    return feed;
}

-(NSDictionary*)getRequest:(NSURL *)URL
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]initWithURL:URL] autorelease];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resopnseMsg = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    SBJsonParser *jsonPar =[SBJsonParser new];
    id returnvalue = [jsonPar objectWithString:resopnseMsg error:NULL];
    NSDictionary *feed = (NSDictionary *)returnvalue;

    return feed;
}


@end
