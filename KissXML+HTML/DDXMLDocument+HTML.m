#import "DDXMLDocument+HTML.h"
#import "DDXMLPrivate.h"

enum {
    XMLDocument,
    HTMLDocument
};
typedef NSUInteger DocumentContent;

@implementation DDXMLDocument (HTML)

- (id) initWithHTMLData: (NSData*) data encoding: (NSStringEncoding) encoding options: (NSUInteger) options error: (NSError**) error
{
    
    CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
    const char *enc = CFStringGetCStringPtr(cfencstr, 0);
    
    if (data == nil || [data length] == 0)
    {
        if (error) *error = [NSError errorWithDomain:@"DDXMLErrorDomain" code:0 userInfo:nil];
        
        return nil;
    }
    xmlKeepBlanksDefault(0);
    
    xmlDocPtr doc =htmlReadMemory (data.bytes, data.length, "", enc, options);
    if (doc == NULL)
    {
        if (error) *error = [NSError errorWithDomain:@"DDXMLErrorDomain" code:1 userInfo:nil];
        
        return nil;
    }
    
    return [self initWithDocPrimitive:doc owner:nil];
}

- (id) initWithHTMLString: (NSString*) string options: (NSUInteger) options error: (NSError**) error
{
    return [self initWithHTMLData: [string dataUsingEncoding: NSUTF8StringEncoding]
                          options: options error: error];
}

- (id) initWithHTMLData: (NSData*) data options: (NSUInteger) options error: (NSError**) error
{
    return [self initWithHTMLData: data encoding: NSUTF8StringEncoding options: options error: error];
}
@end
