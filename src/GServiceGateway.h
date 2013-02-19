//
//  GServiceGateway.h
//  DarknessMap
//
//  Created by Emiliano Burgos on 2/18/13.
//
//

#import <Foundation/Foundation.h>

@interface GServiceGateway : NSObject


- (BOOL)connectionPOST:(NSURLRequest *)aRequest
            withParams:(NSDictionary *)aDictionary;
@end
