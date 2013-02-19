//
//  GPayload.m
//  DarknessMap
//
//  Created by Emiliano Burgos on 2/18/13.
//
//

#import "GPayload.h"

@implementation GPayload

@synthesize loc;
@synthesize time;
@synthesize payload;
@synthesize payloadType;
@synthesize sid;
@synthesize uid;

/**
 *
 */
- (id) initWithUid:(NSString*)Uid sid:(NSString*)Sid
{
    
    if ((self=[super init])==nil) {
        return nil;
    }
    
    sid = Sid;
    uid = Uid;
    payloadType = @"geo";
    
    return self;
}

/**
 *
 */
-(void) setPayload:(NSNumber *)Payload location:(NSDictionary*)Loc timestamp:(NSInteger *)Time
{
    loc = Loc;
    payload = Payload;
    time = Time;
}


- (NSDictionary*) getAsDictionary
{
        
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          payload,@"payload",
                          payloadType,@"payloadType",
                          loc,@"loc",
                          uid,@"uid",
                          sid,@"sid",
                          time,@"time",
                          nil];
    return dict;
}


@end
