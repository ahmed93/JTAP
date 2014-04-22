//
//  Groups.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/29/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "Groups.h"

@implementation Groups

@synthesize Group_Name,Group_ID;

-(id)init:(NSString*) code:(NSString*) _ID
{
    self = [super init];
    if (self) {
        Group_Name = code;
        Group_ID = _ID;
    }
    return self;
}


- (NSString *)description {
    NSString *s = [NSString stringWithFormat:@"{\"Group Number\" = \"%@\"}",Group_Name];
    return s;
}


@end
