//
//  PDFDataAgregator.m
//  wemediacm
//
//  Created by Nuno Martins on 11/07/17.
//  Copyright 2011 WeTouch. All rights reserved.
//

#import "VideoCaptionParser.h"

@interface VideoCaptionParser()

@property(nonatomic, strong) NSMutableArray * listOfCaptions;
@end

@implementation VideoCaptionParser
@synthesize listOfCaptions;
@synthesize dictOfExercices;

- (void) loadDataFromXml
{
    
   //Initialize arrays.
    listOfCaptions = [[NSMutableArray alloc] init];
    dictOfExercices = [[NSMutableDictionary alloc] init];
    
   NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"mindfulness_captions" ofType:@"xml"];
    
    //NSURL *url = [NSURL URLWithString:[AppSettings getXmlPdfUrl]];
    NSURL *url = [NSURL fileURLWithPath: contentPath];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];

    [parser setDelegate:self];
    [parser parse];
    
    
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    

    if(![_elementoActual isEqualToString:@""]){
        _elementoActual = @"";
    }
   
	
    if([elementName isEqualToString:@"Parenting2GO"])
    {
        //Base Element
        
         _elementoActual = [ NSString stringWithFormat:@"%@",elementName ];
        
    }
    else if([elementName isEqualToString:@"Content"])
    {
        
        dictionaryKey = [attributeDict objectForKey:@"title"];
        NSLog(@"%@", dictionaryKey);
         _elementoActual = [ NSString stringWithFormat:@"%@",elementName ];
    }
    else if([elementName isEqualToString:@"Caption"])
    {
        aCaption = [[Caption alloc] init];
        
        aCaption.start = [self getMiliSecondsFromTimeString:[attributeDict objectForKey:@"start"]];
        aCaption.end = [self getMiliSecondsFromTimeString:[attributeDict objectForKey:@"end"]];
        _elementoActual = [ NSString stringWithFormat:@"%@",elementName ];
        
        
    }        
    
}


-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
    NSString *str = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    // Extrair os dados de texto do Bloco CDATA dos vários campos
    
    //NSLog(@"%@", str);
    
    if( [_elementoActual isEqualToString:@"Caption"]){
        
        NSRange r;
        
        while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            str = [str stringByReplacingCharactersInRange:r withString:@""];
        }
        aCaption.mainText = str;
        
    }    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName {
    

    if ( [elementName isEqualToString:@"Caption"] ) {
        
        [listOfCaptions addObject:aCaption];
        
        successful = YES;
        
    }
    
    if ([elementName isEqualToString:@"Content"]) {
        
        NSMutableArray * captionsArray = [[NSMutableArray alloc] initWithArray:listOfCaptions];
        [listOfCaptions removeAllObjects];
        
        [dictOfExercices setObject:captionsArray forKey:dictionaryKey];
    }
    
    _elementoActual = @"";
    
    [_dadosTexto setString:@""];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(![_dadosTexto isEqualToString:@""]){
        [_dadosTexto setString:@""];
    }

/*
    for (Caption *myCaption in listOfCaptions) {
        
        NSLog(@"%@", myCaption.mainText);
    }
*/ 
    
    [self.delegate xmlParseCompleted:dictOfExercices];
}


-(NSNumber *)getMiliSecondsFromTimeString:(NSString *)time{

    
        NSScanner *captionTimeScanner = [NSScanner scannerWithString:time];
        [captionTimeScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" \n\t:"]];
        int minute,second;
        [captionTimeScanner scanInt:&minute];
        [captionTimeScanner scanInt:&second];
        NSLog(@"converting time '%@' to %d:%d\n",time,minute,second);
        int ms = second * 1000 + minute * 60000;
    
    return [NSNumber numberWithInt:ms];

}


@end
