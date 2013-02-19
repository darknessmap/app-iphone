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
@property (assign, nonatomic) NSNumber* payload;
@property (assign, nonatomic) NSDictionary* loc;
@property (assign, nonatomic) NSInteger* time;


- (id) initWithUid:(NSString*)Uid sid:(NSString*)Sid;

-(void) setPayload:(NSNumber *)Payload location:(NSDictionary*)Loc timestamp:(NSInteger *)Time;

- (NSDictionary*) getAsDictionary;
@end
