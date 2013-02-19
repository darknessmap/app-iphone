//
//  GServiceGateway.m
//  DarknessMap
//
//  Created by Emiliano Burgos on 2/18/13.
//
//

#import "GServiceGateway.h"

@implementation GServiceGateway

- (BOOL)connectionPOST:(NSURLRequest *)aRequest
            withParams:(NSDictionary *)aDictionary {
    
    if ([aDictionary count] > 0) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[aRequest URL]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *postString = [[NSMutableString alloc] init];
        NSArray *allKeys = [aDictionary allKeys];
        for (int i = 0; i < [allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aDictionary objectForKey:key];
            [postString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), key, value];
        }
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        [postString release];
        postString = nil;
        
        [request release];
        request = nil;
        
        return YES;
    } else {
        return NO;
    }
}

@end
