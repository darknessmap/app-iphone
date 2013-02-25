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
@synthesize dictionary;

/**
 *
 */
- (id) initWithUid:(NSString*)Uid sid:(NSString*)Sid
{
    
    if ((self=[super init])==nil) {
        return nil;
    }
    
    self.sid = Sid;
    self.uid = Uid;
    self.payloadType = @"geo";
    
    return self;
}

/**
 *
 */
-(void) setPayload:(NSNumber *)Payload location:(NSDictionary*)Loc timestamp:(NSInteger *)Time
{
    self.loc = Loc;
    self.payload = Payload;
    self.time = Time;
}


- (NSDictionary*) getAsDictionary
{
        
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          payload,@"payload",
                          payloadType,@"payloadType",
                          loc,@"loc",
                          uid,@"uid",
                          sid,@"sid",
                          time,@"time",
                          nil];
    return dictionary;
}

- (NSString*) getAsJsonString:(NSMutableDictionary*)ratainer
{

    //Basically, i need to hold this somewhere else...
    [ratainer setValue:payload forKey:@"payload"];
    [ratainer setValue:payloadType forKey:@"payloadType"];
    [ratainer setValue:loc forKey:@"loc"];
    [ratainer setValue:uid forKey:@"uid"];
    [ratainer setValue:sid forKey:@"sid"];
    //Really? Does it have to be this fucking complex?! WTFFY?!!
    [ratainer setValue:[NSNumber numberWithInteger:*(time)] forKey:@"time"];
    
    NSError* error = nil;
    
    /*
    SO, THIS ONE HERE GET FUCKING GETTING ARCed AND WE GET A EXT_BAD_ACCESS BS.
    What do you do? how do you prevent this fucker from being GCed?! Usually the 
    pain is the other way around?!
    Also, if we use a dictionary from GPayload instance...does not work either. 
    //NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          self.payload,@"payload",
                          self.payloadType,@"payloadType",
                          self.loc,@"loc",
                          self.uid,@"uid",
                          self.sid,@"sid",
                          self.time,@"time",
                          nil];*/
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ratainer
                                            options:NSJSONWritingPrettyPrinted
                                            error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    return jsonString;

}

@end
