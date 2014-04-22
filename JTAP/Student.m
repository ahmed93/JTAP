//
//  Student.m
//  JTAP
//
//  Created by Ahmed Mohamed Fareed on 1/31/13.
//  Copyright (c) 2013 Ahmed Mohamed Fareed. All rights reserved.
//

#import "Student.h"

@implementation Student
{
   
}

@synthesize _ID,name,uid,group;

-(id)init:(NSString*) _id:(NSString*) _name :(NSString*) _uid :(Groups*) _group
{
    self = [super init];
    if (self) {
        _ID = _id;
        name = _name;
        uid = _uid;
        group = _group;
    }
    return self;
}




- (NSString *)description {
    NSString *s = [NSString stringWithFormat:@"{\"name\" = \"%@\" , \"uid\" = \"%@\"}",name,uid];
    return s;
}


@end
