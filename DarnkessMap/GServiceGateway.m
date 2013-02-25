//
//  GServiceGateway.m
//  DarknessMap
//
//  Created by Emiliano Burgos on 2/18/13.
//
//

#import "GServiceGateway.h"

@implementation GServiceGateway

- (BOOL)connectionPOST:(NSString *)url
            withParams:(NSDictionary *)aDictionary {
    
    if ([aDictionary count] > 0) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        //FUCK YOU, WHY CANT YOU USE A STRING!!!
                                        initWithURL:[NSURL URLWithString:url]
                                        ];
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *postString = [[NSMutableString alloc] init];
        NSArray *allKeys = [aDictionary allKeys];
        for (int i = 0; i < [allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aDictionary objectForKey:key];
            [postString appendFormat:( (i == 0) ? @"%@=%@" : @"&%@=%@" ), key, value];
        }
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postString length]];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        postString = nil;
        
        request = nil;
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)connectionPOST:(NSString *)url
            withString:(NSString *)aString {
    
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                         initWithURL:[NSURL URLWithString:url]
                                       ];
    
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
        NSString *postLength = [NSString stringWithFormat:@"%d", [aString length]];
    
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
        [request setHTTPBody:[aString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        request = nil;
        
        return YES;
}

@end
