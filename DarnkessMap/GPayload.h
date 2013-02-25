//
//  GPayload.h
//  DarknessMap
//
//  Created by Emiliano Burgos on 2/18/13.
//
//

#import <Foundation/Foundation.h>

@interface GPayload : NSObject

@property (copy,nonatomic) NSString* uid;
@property (copy,nonatomic) NSString* sid;
@property (copy, nonatomic) NSString* payloadType;
@property (weak, nonatomic) NSNumber* payload;
@property (weak, nonatomic) NSDictionary* loc;
@property (assign, nonatomic) NSInteger* time;

//TODO: Give it a fucking real name, yo! 
@property (assign, nonatomic) NSDictionary* dictionary;


- (id) initWithUid:(NSString*)Uid sid:(NSString*)Sid;

-(void) setPayload:(NSNumber *)Payload location:(NSDictionary*)Loc timestamp:(NSInteger *)Time;

- (NSDictionary*) getAsDictionary;

- (NSString*) getAsJsonString:(NSMutableDictionary*)ratainer;


@end
