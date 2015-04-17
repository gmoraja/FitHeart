//
//  PDFDataAgregator.h
//  wemediacm
//
//  Created by Nuno Martins on 11/07/17.
//  Copyright 2011 WeTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Caption.h"

@protocol VideoCaptionParserDelegate;

@interface VideoCaptionParser : NSObject <NSXMLParserDelegate>{

    NSString * dictionaryKey;
    
    Caption * aCaption;
    NSString *_elementoActual;
    NSMutableString *_dadosTexto;
    BOOL successful;
}

@property(nonatomic, strong) NSMutableDictionary * dictOfExercices;
@property(nonatomic, assign) id<VideoCaptionParserDelegate> delegate;

- (void)loadDataFromXml;

@end

@protocol VideoCaptionParserDelegate <NSObject>

@required
-(void) xmlParseCompleted:(NSMutableDictionary *)parsedCaptions;

@end

