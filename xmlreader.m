//
//  xmlreader.m
//
//  Created by vivek Rajanna on 18/02/12.
//  Copyright (c) 2012 vivekrajanna@gmail.com. All rights reserved.
//

#import "xmlreader.h"
#import "DDXML.h"

NSString *const kXMLReaderTextNodeKey =@"text";


@implementation XMLReader

@interface XMLReader (Internal)
-(NSDictionary*) parseChild:(DDXMLElement*)element;
@end


+(NSDictionary*) parseChild:(DDXMLElement*)element
{
    NSMutableDictionary *parsedDict = [[[NSMutableDictionary alloc]init]autorelease];
    
    NSArray *childs = [element children];
    
    for(int i=0;i<[childs count];i++)
    {
        DDXMLElement *sub = [childs objectAtIndex:i];
        
        if([[sub children] count]<=1)
        {
            NSLog(@"name is %@ value is %@",[sub stringValue],sub.name);
            [parsedDict setObject:[sub stringValue] forKey:sub.name];  
            
        }
        else
        {
            NSLog(@"dict for %@",sub.name);  
            NSDictionary *subDict= [self parseChild:sub];
            [parsedDict setObject:subDict forKey:sub.name];
        }
        
    }
    
    return parsedDict;
    
}


#pragma mark -#pragma mark Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    DDXMLDocument *document = [[DDXMLDocument alloc]initWithData:data options:1 error:nil];
    if(!document)
    {
        *error = [NSError errorWithDomain:@"parseError" code:100 userInfo:nil];
        return nil;
    }
    DDXMLElement *elment = [document rootElement];
    return  [XMLReader parseChild:elment];
}


@end
