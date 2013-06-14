//
//  KissXMLTests.m
//  KissXML
//
//  Created by Tobias Kräntzer on 10.06.13.
//

#import "DDXML.h"

#import "KissXMLTests.h"

@implementation KissXMLTests

- (void)testName
{
    NSString *str = @"<body xmlns:food='http://example.com/' food:genre='italian'>"
    @"  <food:pizza>yumyum</food:pizza>"
    @"</body>";
	
	NSError *error = nil;
	
	NSXMLElement *nsBody = [[NSXMLElement alloc] initWithXMLString:str error:&error];
	DDXMLElement *ddBody = [[DDXMLElement alloc] initWithXMLString:str error:&error];
	
	// Test 1 - elements
	
	NSString *nsNodeName = [[nsBody childAtIndex:0] name];
	NSString *ddNodeName = [[ddBody childAtIndex:0] name];
	
    STAssertEqualObjects(nsNodeName, ddNodeName, @"Initializing an element with an XML string does not retunr the expected result.");
	
	// Test 2 - attributes
	
	NSString *nsAttrName = [[nsBody attributeForName:@"food:genre"] name];
	NSString *ddAttrName = [[ddBody attributeForName:@"food:genre"] name];
	
    STAssertEqualObjects(nsAttrName, ddAttrName, @"Initializing an element with an XML string does not retunr the expected result.");
}

- (void)testLocalName
{
    NSString *nsTest1 = [NSXMLNode localNameForName:@"a:quack"];
	NSString *ddTest1 = [DDXMLNode localNameForName:@"a:quack"];
	
    STAssertEqualObjects(nsTest1, ddTest1, @"The behaviour of +[DDXMLNode localNameForName:] differs from +[NSXMLNode localNameForName:].");
	
	NSString *nsTest2 = [NSXMLNode localNameForName:@"a:a:quack"];
	NSString *ddTest2 = [DDXMLNode localNameForName:@"a:a:quack"];
	
	STAssertEqualObjects(nsTest2, ddTest2, @"The behaviour of +[DDXMLNode localNameForName:] differs from +[NSXMLNode localNameForName:].");
	
	NSString *nsTest3 = [NSXMLNode localNameForName:@"quack"];
	NSString *ddTest3 = [DDXMLNode localNameForName:@"quack"];
	
	STAssertEqualObjects(nsTest3, ddTest3, @"The behaviour of +[DDXMLNode localNameForName:] differs from +[NSXMLNode localNameForName:].");
	
	NSString *nsTest4 = [NSXMLNode localNameForName:@"a:"];
	NSString *ddTest4 = [DDXMLNode localNameForName:@"a:"];
	
	STAssertEqualObjects(nsTest4, ddTest4, @"The behaviour of +[DDXMLNode localNameForName:] differs from +[NSXMLNode localNameForName:].");
	
	NSString *nsTest5 = [NSXMLNode localNameForName:nil];
	NSString *ddTest5 = [DDXMLNode localNameForName:nil];
	
    STAssertNil(nsTest5, @"Expecting nil as the result for the local name on nil.");
    STAssertNil(ddTest5, @"Expecting nil as the result for the local name on nil.");
	
	NSXMLNode *nsNode = [NSXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
	DDXMLNode *ddNode = [DDXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
	
	NSString *nsTest6 = [nsNode localName];
	NSString *ddTest6 = [ddNode localName];
	
    STAssertEqualObjects(nsTest6, ddTest6, @"The local name of both nodes should be the same.");
}

- (void)testPrefixName
{
    NSString *nsTest1 = [NSXMLNode prefixForName:@"a:quack"];
	NSString *ddTest1 = [DDXMLNode prefixForName:@"a:quack"];
    
    STAssertEqualObjects(nsTest1, ddTest1, @"The behaviour of +[DDXMLNode prefixForName:] differs from +[NSXMLNode prefixForName:].");
	
	NSString *nsTest2 = [NSXMLNode prefixForName:@"a:a:quack"];
	NSString *ddTest2 = [DDXMLNode prefixForName:@"a:a:quack"];
	
	STAssertEqualObjects(nsTest2, ddTest2, @"The behaviour of +[DDXMLNode prefixForName:] differs from +[NSXMLNode prefixForName:].");
	
	NSString *nsTest3 = [NSXMLNode prefixForName:@"quack"];
	NSString *ddTest3 = [DDXMLNode prefixForName:@"quack"];
	
	STAssertEqualObjects(nsTest3, ddTest3, @"The behaviour of +[DDXMLNode prefixForName:] differs from +[NSXMLNode prefixForName:].");
	
	NSString *nsTest4 = [NSXMLNode prefixForName:@"a:"];
	NSString *ddTest4 = [DDXMLNode prefixForName:@"a:"];
	
	STAssertEqualObjects(nsTest4, ddTest4, @"The behaviour of +[DDXMLNode prefixForName:] differs from +[NSXMLNode prefixForName:].");
	
	NSString *nsTest5 = [NSXMLNode prefixForName:nil];
	NSString *ddTest5 = [DDXMLNode prefixForName:nil];
	
	STAssertEqualObjects(nsTest5, ddTest5, @"The behaviour of +[DDXMLNode prefixForName:] differs from +[NSXMLNode prefixForName:].");
	
	NSXMLNode *nsNode = [NSXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
	DDXMLNode *ddNode = [DDXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
	
	NSString *nsTest6 = [nsNode prefix];
	NSString *ddTest6 = [ddNode prefix];
    
    STAssertEqualObjects(nsTest6, ddTest6, @"The prefix of the namespace nodes should be the same.");
}

- (void)testDoubleAdd
{
    // NSXML
    
    NSXMLElement *nsRoot1 = [NSXMLElement elementWithName:@"root1"];
	NSXMLElement *nsRoot2 = [NSXMLElement elementWithName:@"root2"];
	
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
	NSXMLNode *nsAttr = [NSXMLNode attributeWithName:@"key" stringValue:@"value"];
	NSXMLNode *nsNs = [NSXMLNode namespaceWithName:@"a" stringValue:@"domain.com"];
    
    STAssertThrows([nsRoot1 addChild:nsAttr], @"Elements can only have text, elements, processing instructions, and comments as children.");
    STAssertThrows([nsRoot1 addAttribute:nsNode], @"Not an attribute");
    STAssertThrows([nsRoot1 addNamespace:nsNode], @"Not a namespace");
    
    [nsRoot1 addChild:nsNode];
    STAssertThrows([nsRoot2 addChild:nsNode], @"Cannot add a child that has a parent; detach or copy first");
    
    [nsRoot1 addAttribute:nsAttr];
    STAssertThrows([nsRoot2 addAttribute:nsAttr], @"Cannot add an attribute with a parent; detach or copy first");
    
    [nsRoot1 addNamespace:nsNs];
    STAssertThrows([nsRoot2 addNamespace:nsNs], @"Cannot add a namespace with a parent; detach or copy first");
    
    // DDXML
    
	DDXMLElement *ddRoot1 = [DDXMLElement elementWithName:@"root1"];
	DDXMLElement *ddRoot2 = [DDXMLElement elementWithName:@"root2"];
	
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
	DDXMLNode *ddAttr = [DDXMLNode attributeWithName:@"key" stringValue:@"value"];
	DDXMLNode *ddNs = [DDXMLNode namespaceWithName:@"a" stringValue:@"domain.com"];
    
    STAssertThrows([ddRoot1 addChild:ddAttr], @"Elements can only have text, elements, processing instructions, and comments as children.");
    STAssertThrows([ddRoot1 addAttribute:ddNode], @"Not an attribute");
    STAssertThrows([ddRoot1 addNamespace:ddNode], @"Not a namespace");
    
    [ddRoot1 addChild:ddNode];
    STAssertThrows([ddRoot2 addChild:ddNode], @"Cannot add a child that has a parent; detach or copy first");
    
    [ddRoot1 addAttribute:ddAttr];
    STAssertThrows([ddRoot2 addAttribute:ddAttr], @"Cannot add an attribute with a parent; detach or copy first");
    
    [ddRoot1 addNamespace:ddNs];
    STAssertThrows([ddRoot2 addNamespace:ddNs], @"Cannot add a namespace with a parent; detach or copy first");
}

- (void)testNSGeneral
{
    NSXMLNode *nsNs = [NSXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"];
	DDXMLNode *ddNs = [DDXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"];
	
	NSString *nsTest1 = [nsNs XMLString];
	NSString *ddTest1 = [ddNs XMLString];
	
    STAssertEqualObjects(nsTest1, ddTest1, @"Constructor for namespace nodes differ in both implementations.");
	
	[nsNs setName:@"b"];
	[ddNs setName:@"b"];
	
	NSString *nsTest2 = [nsNs XMLString];
	NSString *ddTest2 = [ddNs XMLString];
	
    STAssertEqualObjects(nsTest2, ddTest2, @"The setter for 'name' of namespace nodes differ in both implementations.");
	
	[nsNs setStringValue:@"robbiehanson.com"];
	[ddNs setStringValue:@"robbiehanson.com"];
	
	NSString *nsTest3 = [nsNs XMLString];
	NSString *ddTest3 = [ddNs XMLString];
	
    STAssertEqualObjects(nsTest3, ddTest3, @"The setter for 'stringValue' of namespace nodes differ in both implementations.");
}

- (void)testNsLevel
{
    // <root xmlns:a="apple.com">
	//   <node xmlns:d="deusty.com" xmlns:rh="robbiehanson.com"/>
	// </root>
	
	NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
	NSXMLNode *nsNs0 = [NSXMLNode namespaceWithName:@"a" stringValue:@"apple.com"];
	NSXMLNode *nsNs1 = [NSXMLNode namespaceWithName:@"d" stringValue:@"deusty.com"];
	NSXMLNode *nsNs2 = [NSXMLNode namespaceWithName:@"rh" stringValue:@"robbiehanson.com"];
	[nsNode addNamespace:nsNs1];
	[nsNode addNamespace:nsNs2];
	[nsRoot addNamespace:nsNs0];
	[nsRoot addChild:nsNode];
	
	DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
	DDXMLNode *ddNs0 = [DDXMLNode namespaceWithName:@"a" stringValue:@"apple.com"];
	DDXMLNode *ddNs1 = [DDXMLNode namespaceWithName:@"d" stringValue:@"deusty.com"];
	DDXMLNode *ddNs2 = [DDXMLNode namespaceWithName:@"rh" stringValue:@"robbiehanson.com"];
	[ddNode addNamespace:ddNs1];
	[ddNode addNamespace:ddNs2];
	[ddRoot addNamespace:ddNs0];
	[ddRoot addChild:ddNode];
	
    STAssertEquals([nsNs0 index], [ddNs0 index], nil);
    STAssertEquals([nsNs1 index], [ddNs1 index], nil);
    STAssertEquals([nsNs2 index], [ddNs2 index], nil);
    
    STAssertEquals([nsNs0 level], [ddNs0 level], nil);
    STAssertEquals([nsNs1 level], [ddNs1 level], nil);
    STAssertEquals([nsNs2 level], [ddNs2 level], nil);
}

- (void)testNsURI
{
    NSXMLElement *nsNode = [NSXMLElement elementWithName:@"duck" URI:@"quack.com"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"duck" URI:@"quack.com"];
	
	NSString *nsTest1 = [nsNode URI];
	NSString *ddTest1 = [ddNode URI];
	
    STAssertEqualObjects(nsTest1, ddTest1, nil);
	
	[nsNode setURI:@"food.com"];
	[ddNode setURI:@"food.com"];
	
	NSString *nsTest2 = [nsNode URI];
	NSString *ddTest2 = [ddNode URI];
	
	STAssertEqualObjects(nsTest2, ddTest2, nil);
	
	NSXMLNode *nsAttr = [NSXMLNode attributeWithName:@"duck" URI:@"quack.com" stringValue:@"quack"];
	DDXMLNode *ddAttr = [DDXMLNode attributeWithName:@"duck" URI:@"quack.com" stringValue:@"quack"];
	
	NSString *nsTest3 = [nsAttr URI];
	NSString *ddTest3 = [ddAttr URI];
	
    STAssertEqualObjects(nsTest3, ddTest3, nil);
	
	[nsAttr setURI:@"food.com"];
	[ddAttr setURI:@"food.com"];
	
	NSString *nsTest4 = [nsAttr URI];
	NSString *ddTest4 = [ddAttr URI];
	
    STAssertEqualObjects(nsTest4, ddTest4, nil);
}

- (void)testResolvePrefixForNamespaceURI
{
    // <root xmlns="example.com">
	//   <node />
	// </root>
    
    NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
    NSXMLNode *nsNs = [NSXMLNode namespaceWithName:@"" stringValue:@"example.com"];
    [nsRoot addNamespace:nsNs];
	[nsRoot addChild:nsNode];

    STAssertEqualObjects([nsNode resolvePrefixForNamespaceURI:@"example.com"], @"", nil);
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
	DDXMLNode *ddNs = [DDXMLNode namespaceWithName:@"" stringValue:@"example.com"];
	[ddRoot addNamespace:ddNs];
	[ddRoot addChild:ddNode];
    
    STAssertEqualObjects([ddNode resolvePrefixForNamespaceURI:@"example.com"], @"", nil);
}

- (void)testElementsForLocalNameWithNilURI
{
    // <root xmlns="example.com">
	//   <node />
	// </root>
    
    NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
    NSXMLNode *nsNs = [NSXMLNode namespaceWithName:@"" stringValue:@"example.com"];
    [nsRoot addNamespace:nsNs];
	[nsRoot addChild:nsNode];
    
    STAssertEquals([[nsRoot elementsForLocalName:@"node" URI:nil] count], (NSUInteger)0, nil);
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
	DDXMLNode *ddNs = [DDXMLNode namespaceWithName:@"" stringValue:@"example.com"];
	[ddRoot addNamespace:ddNs];
	[ddRoot addChild:ddNode];
    
    STAssertEquals([[ddRoot elementsForLocalName:@"node" URI:nil] count], (NSUInteger)0, nil);
}

- (void)testElementsForLocalNameWithURI
{
    // <root xmlns="example.com">
	//   <node />
	// </root>
    
    NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
    NSXMLNode *nsNs = [NSXMLNode namespaceWithName:@"" stringValue:@"example.com"];
    [nsRoot addNamespace:nsNs];
	[nsRoot addChild:nsNode];
    
    NSArray *nsElements = [nsRoot elementsForLocalName:@"node" URI:@"example.com"];
    STAssertEquals([nsElements count], (NSUInteger)1, nil);
    if ([nsElements count] == 1) {
        STAssertEqualObjects([[nsElements objectAtIndex:0] name], @"node", nil);
    }
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
	DDXMLNode *ddNs = [DDXMLNode namespaceWithName:@"" stringValue:@"example.com"];
	[ddRoot addNamespace:ddNs];
	[ddRoot addChild:ddNode];
    
    NSArray *ddElements = [ddRoot elementsForLocalName:@"node" URI:@"example.com"];
    STAssertEquals([ddElements count], (NSUInteger)1, nil);
    if ([ddElements count] == 1) {
        STAssertEqualObjects([[ddElements objectAtIndex:0] name], @"node", nil);
    }
}

- (void)testElementsForLocalNameWithURI2
{
    // <root xmlns="example.com">
	//   <node xmlns="test"/>
	// </root>
    
    NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"node"];
    [nsNode addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"test"]];
    [nsRoot addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"example.com"]];
	[nsRoot addChild:nsNode];
    
    NSArray *nsElements = [nsRoot elementsForLocalName:@"node" URI:@"test"];
    STAssertEquals([nsElements count], (NSUInteger)1, nil);
    if ([nsElements count] == 1) {
        STAssertEqualObjects([[nsElements objectAtIndex:0] name], @"node", nil);
    }
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"node"];
    [ddNode addNamespace:[DDXMLNode namespaceWithName:@"" stringValue:@"test"]];
	[ddRoot addNamespace:[DDXMLNode namespaceWithName:@"" stringValue:@"example.com"]];
	[ddRoot addChild:ddNode];
    
    NSArray *ddElements = [ddRoot elementsForLocalName:@"node" URI:@"test"];
    STAssertEquals([ddElements count], (NSUInteger)1, nil);
    if ([ddElements count] == 1) {
        STAssertEqualObjects([[ddElements objectAtIndex:0] name], @"node", nil);
    }
}

- (void)testAddAttr
{
    NSString *attrName  = @"artist";
	
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"song"];
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"song"];
	
	// Test adding an attribute
	
	NSString *attrValue1 = @"John Mayer";
	
	NSXMLNode *nsAttr1 = [NSXMLNode attributeWithName:attrName stringValue:attrValue1];
	DDXMLNode *ddAttr1 = [DDXMLNode attributeWithName:attrName stringValue:attrValue1];
	
	[nsNode addAttribute:nsAttr1];
	[ddNode addAttribute:ddAttr1];
	
	NSString *nsAttrValue1 = [[nsNode attributeForName:attrName] stringValue];
	NSString *ddAttrValue1 = [[ddNode attributeForName:attrName] stringValue];
	
	STAssertTrue([nsAttrValue1 isEqualToString:attrValue1], @"Failed CHECK 1");
	STAssertTrue([ddAttrValue1 isEqualToString:attrValue1], @"Failed test 1");
	
	// Test replacing an attribute
	
	NSString *attrValue2 = @"Paramore";
	
	NSXMLNode *nsAttr2 = [NSXMLNode attributeWithName:attrName stringValue:attrValue2];
	DDXMLNode *ddAttr2 = [DDXMLNode attributeWithName:attrName stringValue:attrValue2];
	
	[nsNode addAttribute:nsAttr2];
	[ddNode addAttribute:ddAttr2];
	
	// The documentation for NSXMLElement's addAttribute: method says this:
	//
	// "If the receiver already has an attribute with the same name, anAttribute is not added."
	//
	// However, this is NOT the case.
	// If the receiver already has an attribute with the same name, the previous attribute is replaced.
	//
	// Considering the fact that the API does NOT contain a setAttribute method,
	// I believe this should be the desired functionality.
	//
	// We match the functionality rather than the documentation.
	
	NSString *nsAttrValue2 = [[nsNode attributeForName:attrName] stringValue];
	NSString *ddAttrValue2 = [[ddNode attributeForName:attrName] stringValue];
	
	STAssertTrue([nsAttrValue2 isEqualToString:attrValue2], @"Failed CHECK 2");
	STAssertTrue([ddAttrValue2 isEqualToString:attrValue2], @"Failed test 2");
	
	// Test removing an attribute
	
	[nsNode removeAttributeForName:attrName];
	[ddNode removeAttributeForName:attrName];
	
	STAssertTrue([nsNode attributeForName:attrName] == nil, @"Failed CHECK 3");
	STAssertTrue([ddNode attributeForName:attrName] == nil, @"Failed test 3");
	
	// Test detaching an attribute
	
	NSString *attrValue3 = @"Katy Perry";
	
	NSXMLNode *nsAttr3 = [NSXMLNode attributeWithName:attrName stringValue:attrValue3];
	DDXMLNode *ddAttr3 = [DDXMLNode attributeWithName:attrName stringValue:attrValue3];
	
	[nsNode addAttribute:nsAttr3];
	[ddNode addAttribute:ddAttr3];
	
	NSString *nsAttrValue3 = [[nsNode attributeForName:attrName] stringValue];
	NSString *ddAttrValue3 = [[ddNode attributeForName:attrName] stringValue];
	
	STAssertTrue([nsAttrValue3 isEqualToString:attrValue3], @"Failed CHECK 4");
	STAssertTrue([ddAttrValue3 isEqualToString:attrValue3], @"Failed test 4");
	
	[nsAttr3 detach];
	[ddAttr3 detach];
	
	STAssertTrue([nsNode attributeForName:attrName] == nil, @"Failed CHECK 5");
	STAssertTrue([ddNode attributeForName:attrName] == nil, @"Failed test 5");
	
	// Test reattaching an attribute
	
	[nsNode addAttribute:nsAttr3];
	[ddNode addAttribute:ddAttr3];
	
	nsAttrValue3 = [[nsNode attributeForName:attrName] stringValue];
	ddAttrValue3 = [[ddNode attributeForName:attrName] stringValue];
	
	STAssertTrue([nsAttrValue3 isEqualToString:attrValue3], @"Failed CHECK 6");
	STAssertTrue([ddAttrValue3 isEqualToString:attrValue3], @"Failed test 6");
}

- (void)testAttrGeneral
{
    NSXMLNode *nsAttr = [NSXMLNode attributeWithName:@"apple" stringValue:@"inc"];
	DDXMLNode *ddAttr = [DDXMLNode attributeWithName:@"apple" stringValue:@"inc"];
	
	NSString *nsStr1 = [nsAttr XMLString];
	NSString *ddStr1 = [ddAttr XMLString];
	
	STAssertTrue([nsStr1 isEqualToString:ddStr1], @"Failed test 1");
	
	[nsAttr setName:@"deusty"];
	[ddAttr setName:@"deusty"];
	
	NSString *nsStr2 = [nsAttr XMLString];
	NSString *ddStr2 = [ddAttr XMLString];
	
	STAssertTrue([nsStr2 isEqualToString:ddStr2], @"Failed test 2");
	
	[nsAttr setStringValue:@"designs"];
	[ddAttr setStringValue:@"designs"];
	
	NSString *nsStr3 = [nsAttr XMLString];
	NSString *ddStr3 = [ddAttr XMLString];
	
	STAssertTrue([nsStr3 isEqualToString:ddStr3], @"Failed test 3");
}

- (void)testAttrSiblings
{
    // <duck sound="quack" swims="YES" flys="YES"/>
	
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"duck"];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
	
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"duck"];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
	
	NSXMLNode *nsAttr = [nsNode attributeForName:@"swims"];
	DDXMLNode *ddAttr = [ddNode attributeForName:@"swims"];
	
	NSString *nsTest1 = [nsAttr XMLString];
	NSString *ddTest1 = [ddAttr XMLString];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
	
    //	NSLog(@"nsAttr prev: %@", [[nsAttr previousSibling] XMLString]);  // nil
    //	NSLog(@"nsAttr next: %@", [[nsAttr nextSibling] XMLString]);      // nil
	
    //	NSLog(@"ddAttr prev: %@", [[ddAttr previousSibling] XMLString]);  // sound="quack"
    //	NSLog(@"ddAttr next: %@", [[ddAttr nextSibling] XMLString]);      // flys="YES"
	
    //	Analysis: DDXML works and NSXML doesn't. I see no need to cripple DDXML because of that.
}

- (void)testAttrDocOrder
{
    // <duck sound="quack" swims="YES" flys="YES"/>
	
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"duck"];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
	[nsNode addAttribute:[NSXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
	
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"duck"];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
	[ddNode addAttribute:[DDXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
	
	NSXMLNode *nsAttr = [nsNode attributeForName:@"swims"];
	DDXMLNode *ddAttr = [ddNode attributeForName:@"swims"];
	
	NSXMLNode *nsTest1 = [nsAttr previousNode];
	DDXMLNode *ddTest1 = [ddAttr previousNode];
	
	STAssertTrue((!nsTest1 && !ddTest1), @"Failed test 1");
	
	NSXMLNode *nsTest2 = [nsAttr nextNode];
	DDXMLNode *ddTest2 = [ddAttr nextNode];
	
	STAssertTrue((!nsTest2 && !ddTest2), @"Failed test 2");
	
	// Notes: Attributes play no part in the document order.
}

- (void)testAttrChildren
{
    NSXMLNode *nsAttr1 = [NSXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
    DDXMLNode *ddAttr1 = [DDXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
    
    NSXMLNode *nsTest1 = [nsAttr1 childAtIndex:0];
    DDXMLNode *ddTest1 = [ddAttr1 childAtIndex:0];
    
    STAssertTrue((!nsTest1 && !ddTest1), @"Failed test 1");
    
    NSUInteger nsTest2 = [nsAttr1 childCount];
    NSUInteger ddTest2 = [ddAttr1 childCount];
    
    STAssertTrue((nsTest2 == ddTest2), @"Failed test 2");
    
    NSArray *nsTest3 = [nsAttr1 children];
    NSArray *ddTest3 = [ddAttr1 children];
    
    STAssertTrue((!nsTest3 && !ddTest3), @"Failed test 3");
    
    // Notes: Attributes aren't supposed to have children, although in libxml they technically do.
    // The child is simply a pointer to a text node, which contains the attribute value.
    
}

- (void)testString
{
	// <pizza>
	//   <toppings>
	//     <pepperoni/>
	//     <sausage>
	//       <mild/>
	//       <spicy/>
	//     </sausage>
	//   </toppings>
	//   <crust>
	//     <thin/>
	//     <thick/>
	//   </crust>
	// </pizza>
	
	NSXMLElement *nsNode0 = [NSXMLElement elementWithName:@"pizza"];
	NSXMLElement *nsNode1 = [NSXMLElement elementWithName:@"toppings"];
	NSXMLElement *nsNode2 = [NSXMLElement elementWithName:@"pepperoni"];
	NSXMLElement *nsNode3 = [NSXMLElement elementWithName:@"sausage"];
	NSXMLElement *nsNode4 = [NSXMLElement elementWithName:@"mild"];
	NSXMLElement *nsNode5 = [NSXMLElement elementWithName:@"spicy"];
	NSXMLElement *nsNode6 = [NSXMLElement elementWithName:@"crust"];
	NSXMLElement *nsNode7 = [NSXMLElement elementWithName:@"thin"];
	NSXMLElement *nsNode8 = [NSXMLElement elementWithName:@"thick"];
	
	[nsNode0 addChild:nsNode1];
	[nsNode0 addChild:nsNode6];
	[nsNode1 addChild:nsNode2];
	[nsNode1 addChild:nsNode3];
	[nsNode3 addChild:nsNode4];
	[nsNode3 addChild:nsNode5];
	[nsNode6 addChild:nsNode7];
	[nsNode6 addChild:nsNode8];
	
	DDXMLElement *ddNode0 = [DDXMLElement elementWithName:@"pizza"];
	DDXMLElement *ddNode1 = [DDXMLElement elementWithName:@"toppings"];
	DDXMLElement *ddNode2 = [DDXMLElement elementWithName:@"pepperoni"];
	DDXMLElement *ddNode3 = [DDXMLElement elementWithName:@"sausage"];
	DDXMLElement *ddNode4 = [DDXMLElement elementWithName:@"mild"];
	DDXMLElement *ddNode5 = [DDXMLElement elementWithName:@"spicy"];
	DDXMLElement *ddNode6 = [DDXMLElement elementWithName:@"crust"];
	DDXMLElement *ddNode7 = [DDXMLElement elementWithName:@"thin"];
	DDXMLElement *ddNode8 = [DDXMLElement elementWithName:@"thick"];
	
	[ddNode0 addChild:ddNode1];
	[ddNode0 addChild:ddNode6];
	[ddNode1 addChild:ddNode2];
	[ddNode1 addChild:ddNode3];
	[ddNode3 addChild:ddNode4];
	[ddNode3 addChild:ddNode5];
	[ddNode6 addChild:ddNode7];
	[ddNode6 addChild:ddNode8];
	
	NSXMLNode *nsAttr1 = [NSXMLNode attributeWithName:@"price" stringValue:@"1.00"];
	DDXMLNode *ddAttr1 = [DDXMLNode attributeWithName:@"price" stringValue:@"1.00"];
	
	[nsNode1 addAttribute:nsAttr1];
	[ddNode1 addAttribute:ddAttr1];
	
	[nsNode4 setStringValue:@"<just right>"];
	[ddNode4 setStringValue:@"<just right>"];
	
	[nsNode5 setStringValue:@"too hot"];
	[ddNode5 setStringValue:@"too hot"];
	
	NSString *nsTest1 = [nsNode0 stringValue];  // Returns "<just right>too hot"
	NSString *ddTest1 = [ddNode0 stringValue];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
	
	NSString *nsTest2 = [nsAttr1 stringValue];  // Returns "1.00"
	NSString *ddTest2 = [ddAttr1 stringValue];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
	
	[nsAttr1 setStringValue:@"1.25"];
	[ddAttr1 setStringValue:@"1.25"];
	
	NSString *nsTest3 = [nsAttr1 stringValue];  // Returns "1.25"
	NSString *ddTest3 = [ddAttr1 stringValue];
	
	STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
	
	[nsNode0 setStringValue:@"<wtf>ESCAPE</wtf>"];
	[ddNode0 setStringValue:@"<wtf>ESCAPE</wtf>"];
	
	NSString *nsTest4 = [nsNode0 stringValue];  // Returns "<wtf>ESCAPE</wtf>"
	NSString *ddTest4 = [ddNode0 stringValue];
	
	STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
	
    //	NSString *nsTest5 = [nsNode0 XMLString];  // Returns "<pizza>&lt;wtf>ESCAPE&lt;/wtf></pizza>"
    //	NSString *ddTest5 = [ddNode0 XMLString];  // Returns "<pizza>&lt;wtf&gt;ESCAPE&lt;/wtf&gt;</pizza>"
    //
    //	NSAssert2([nsTest5 isEqualToString:ddTest5], @"Failed test 5 - ns(%@) dd(%@)", nsTest5, ddTest5);
    //
    //  The DDXML version is actually more accurate, so we'll accept the difference.
	
}

- (void)testChildren
{
	NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<beers>            "];
	[xmlStr appendString:@"  <sam_adams/>     "];
	[xmlStr appendString:@"  <left_hand/>     "];
	[xmlStr appendString:@"  <goose_island/>  "];
	[xmlStr appendString:@" <!-- budweiser -->"];
	[xmlStr appendString:@"</beers>           "];
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	NSUInteger nsChildCount = [[nsDoc rootElement] childCount];
	NSUInteger ddChildCount = [[ddDoc rootElement] childCount];
	
	STAssertTrue(nsChildCount == ddChildCount, @"Failed test 1");
	
	NSArray *nsChildren = [[nsDoc rootElement] children];
	NSArray *ddChildren = [[ddDoc rootElement] children];
	
	STAssertTrue([nsChildren count] == [ddChildren count], @"Failed test 2");
	
	NSString *nsBeer = [[[nsDoc rootElement] childAtIndex:1] name];
	NSString *ddBeer = [[[ddDoc rootElement] childAtIndex:1] name];
	
	STAssertTrue([nsBeer isEqualToString:ddBeer], @"Failed test 3");
}

- (void)testPreviousNextNode1
{
    // <pizza>
	//   <toppings>
	//     <pepperoni/>
	//     <sausage>
	//       <mild/>
	//       <spicy/>
	//     </sausage>
	//   </toppings>
	//   <crust>
	//     <thin/>
	//     <thick/>
	//   </crust>
	// </pizza>
	
	NSXMLElement *nsNode0 = [NSXMLElement elementWithName:@"pizza"];
	NSXMLElement *nsNode1 = [NSXMLElement elementWithName:@"toppings"];
	NSXMLElement *nsNode2 = [NSXMLElement elementWithName:@"pepperoni"];
	NSXMLElement *nsNode3 = [NSXMLElement elementWithName:@"sausage"];
	NSXMLElement *nsNode4 = [NSXMLElement elementWithName:@"mild"];
	NSXMLElement *nsNode5 = [NSXMLElement elementWithName:@"spicy"];
	NSXMLElement *nsNode6 = [NSXMLElement elementWithName:@"crust"];
	NSXMLElement *nsNode7 = [NSXMLElement elementWithName:@"thin"];
	NSXMLElement *nsNode8 = [NSXMLElement elementWithName:@"thick"];
	
	[nsNode0 addChild:nsNode1];
	[nsNode0 addChild:nsNode6];
	[nsNode1 addChild:nsNode2];
	[nsNode1 addChild:nsNode3];
	[nsNode3 addChild:nsNode4];
	[nsNode3 addChild:nsNode5];
	[nsNode6 addChild:nsNode7];
	[nsNode6 addChild:nsNode8];
	
	DDXMLElement *ddNode0 = [DDXMLElement elementWithName:@"pizza"];
	DDXMLElement *ddNode1 = [DDXMLElement elementWithName:@"toppings"];
	DDXMLElement *ddNode2 = [DDXMLElement elementWithName:@"pepperoni"];
	DDXMLElement *ddNode3 = [DDXMLElement elementWithName:@"sausage"];
	DDXMLElement *ddNode4 = [DDXMLElement elementWithName:@"mild"];
	DDXMLElement *ddNode5 = [DDXMLElement elementWithName:@"spicy"];
	DDXMLElement *ddNode6 = [DDXMLElement elementWithName:@"crust"];
	DDXMLElement *ddNode7 = [DDXMLElement elementWithName:@"thin"];
	DDXMLElement *ddNode8 = [DDXMLElement elementWithName:@"thick"];
	
	[ddNode0 addChild:ddNode1];
	[ddNode0 addChild:ddNode6];
	[ddNode1 addChild:ddNode2];
	[ddNode1 addChild:ddNode3];
	[ddNode3 addChild:ddNode4];
	[ddNode3 addChild:ddNode5];
	[ddNode6 addChild:ddNode7];
	[ddNode6 addChild:ddNode8];
	
	NSString *nsTest1 = [[nsNode2 nextNode] name];
	NSString *ddTest1 = [[ddNode2 nextNode] name];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1: ns(%@) dd(%@)", nsTest1, ddTest1);
	
	NSString *nsTest2 = [[nsNode3 nextNode] name];
	NSString *ddTest2 = [[ddNode3 nextNode] name];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
	
	NSString *nsTest3 = [[nsNode5 nextNode] name];
	NSString *ddTest3 = [[ddNode5 nextNode] name];
	
	STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3: ns(%@) dd(%@)", nsTest3, ddTest3);
	
	NSString *nsTest4 = [[nsNode5 previousNode] name];
	NSString *ddTest4 = [[ddNode5 previousNode] name];
	
	STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
	
	NSString *nsTest5 = [[nsNode6 previousNode] name];
	NSString *ddTest5 = [[ddNode6 previousNode] name];
	
	STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
	
	NSString *nsTest6 = [[nsNode8 nextNode] name];
	NSString *ddTest6 = [[ddNode8 nextNode] name];
	
	STAssertTrue((!nsTest6 && !ddTest6), @"Failed test 6: ns(%@) dd(%@)", nsTest6, ddTest6);
	
	NSString *nsTest7 = [[nsNode0 previousNode] name];
	NSString *ddTest7 = [[ddNode0 previousNode] name];
	
	STAssertTrue((!nsTest7 && !ddTest7), @"Failed test 7: ns(%@) dd(%@)", nsTest7, ddTest7);
}

- (void)testPreviousNextNode2
{
    NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<pizza>         "];
	[xmlStr appendString:@"  <toppings>    "];
	[xmlStr appendString:@"    <pepperoni/>"];
	[xmlStr appendString:@"    <sausage>   "];
	[xmlStr appendString:@"      <mild/>   "];
	[xmlStr appendString:@"      <spicy/>  "];
	[xmlStr appendString:@"    </sausage>  "];
	[xmlStr appendString:@"  </toppings>   "];
	[xmlStr appendString:@"  <crust>       "];
	[xmlStr appendString:@"    <thin/>     "];
	[xmlStr appendString:@"    <thick/>    "];
	[xmlStr appendString:@"  </crust>      "];
	[xmlStr appendString:@"</pizza>        "];
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	NSXMLNode *nsNode0 = [nsDoc rootElement]; // pizza
	DDXMLNode *ddNode0 = [ddDoc rootElement]; // pizza
	
	NSXMLNode *nsNode2 = [[[nsDoc rootElement] childAtIndex:0] childAtIndex:0]; // pepperoni
	DDXMLNode *ddNode2 = [[[ddDoc rootElement] childAtIndex:0] childAtIndex:0]; // pepperoni
	
	NSXMLNode *nsNode3 = [[[nsDoc rootElement] childAtIndex:0] childAtIndex:1]; // sausage
	DDXMLNode *ddNode3 = [[[ddDoc rootElement] childAtIndex:0] childAtIndex:1]; // sausage
	
	NSXMLNode *nsNode5 = [[[[nsDoc rootElement] childAtIndex:0] childAtIndex:1] childAtIndex:1]; // spicy
	DDXMLNode *ddNode5 = [[[[ddDoc rootElement] childAtIndex:0] childAtIndex:1] childAtIndex:1]; // spicy
	
	NSXMLNode *nsNode6 = [[nsDoc rootElement] childAtIndex:1]; // crust
	DDXMLNode *ddNode6 = [[ddDoc rootElement] childAtIndex:1]; // crust
	
	NSXMLNode *nsNode8 = [[[nsDoc rootElement] childAtIndex:1] childAtIndex:1]; // crust
	DDXMLNode *ddNode8 = [[[ddDoc rootElement] childAtIndex:1] childAtIndex:1]; // crust
	
	NSString *nsTest1 = [[nsNode2 nextNode] name];
	NSString *ddTest1 = [[ddNode2 nextNode] name];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1: ns(%@) dd(%@)", nsTest1, ddTest1);
	
	NSString *nsTest2 = [[nsNode3 nextNode] name];
	NSString *ddTest2 = [[ddNode3 nextNode] name];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
	
	NSString *nsTest3 = [[nsNode5 nextNode] name];
	NSString *ddTest3 = [[ddNode5 nextNode] name];
	
	STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3: ns(%@) dd(%@)", nsTest3, ddTest3);
	
	NSString *nsTest4 = [[nsNode5 previousNode] name];
	NSString *ddTest4 = [[ddNode5 previousNode] name];
	
	STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
	
	NSString *nsTest5 = [[nsNode6 previousNode] name];
	NSString *ddTest5 = [[ddNode6 previousNode] name];
	
	STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
	
	NSString *nsTest6 = [[nsNode8 nextNode] name];
	NSString *ddTest6 = [[ddNode8 nextNode] name];
	
	STAssertTrue((!nsTest6 && !ddTest6), @"Failed test 6: ns(%@) dd(%@)", nsTest6, ddTest6);
	
	NSString *nsTest7 = [[nsNode0 previousNode] name];
	NSString *ddTest7 = [[ddNode0 previousNode] name];
	
	STAssertTrue((!nsTest7 && !ddTest7), @"Failed test 7: ns(%@) dd(%@)", nsTest7, ddTest7);
}

- (void)testPrefix
{
    // <root xmlns:a="beagle" xmlns:b="lab">
	//   <dog/>
	//   <a:dog/>
	//   <a:b:dog/>
	//   <dog xmlns="beagle"/>
	// </root>
	
	NSXMLElement *nsNode1 = [NSXMLElement elementWithName:@"dog"];
	NSXMLElement *nsNode2 = [NSXMLElement elementWithName:@"a:dog"];
	NSXMLElement *nsNode3 = [NSXMLElement elementWithName:@"a:b:dog"];
	NSXMLElement *nsNode4 = [NSXMLElement elementWithName:@"dog" URI:@"beagle"];
	
	DDXMLElement *ddNode1 = [DDXMLElement elementWithName:@"dog"];
	DDXMLElement *ddNode2 = [DDXMLElement elementWithName:@"a:dog"];
	DDXMLElement *ddNode3 = [DDXMLElement elementWithName:@"a:b:dog"];
	DDXMLElement *ddNode4 = [DDXMLElement elementWithName:@"dog" URI:@"beagle"];
	
	NSString *nsTest1 = [nsNode1 prefix];
	NSString *ddTest1 = [ddNode1 prefix];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
	
	NSString *nsTest2 = [nsNode2 prefix];
	NSString *ddTest2 = [ddNode2 prefix];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
	
	NSString *nsTest3 = [nsNode3 prefix];
	NSString *ddTest3 = [ddNode3 prefix];
	
	STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
	
	NSString *nsTest4 = [nsNode4 prefix];
	NSString *ddTest4 = [ddNode4 prefix];
	
	STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
}

- (void)testURI
{
    // <root xmlns:a="deusty.com" xmlns:b="robbiehanson.com">
	//     <test test="1"/>
	//     <a:test test="2"/>
	//     <b:test test="3"/>
	//     <test xmlns="deusty.com" test="4"/>
	//     <test xmlns="quack.com" test="5"/>
	// </root>
	
	NSXMLElement *nsRoot = [NSXMLElement elementWithName:@"root"];
	[nsRoot addNamespace:[NSXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"]];
	[nsRoot addNamespace:[NSXMLNode namespaceWithName:@"b" stringValue:@"robbiehanson.com"]];
	
	NSXMLElement *nsNode1 = [NSXMLElement elementWithName:@"test"];
	[nsNode1 addAttribute:[NSXMLNode attributeWithName:@"test" stringValue:@"1"]];
	
	NSXMLElement *nsNode2 = [NSXMLElement elementWithName:@"a:test"];
	[nsNode2 addAttribute:[NSXMLNode attributeWithName:@"test" stringValue:@"2"]];
	
	NSXMLElement *nsNode3 = [NSXMLElement elementWithName:@"b:test"];
	[nsNode3 addAttribute:[NSXMLNode attributeWithName:@"test" stringValue:@"3"]];
	
	NSXMLElement *nsNode4 = [NSXMLElement elementWithName:@"test" URI:@"deusty.com"];
	[nsNode4 addAttribute:[NSXMLNode attributeWithName:@"test" stringValue:@"4"]];
	
	NSXMLElement *nsNode5 = [NSXMLElement elementWithName:@"test" URI:@"quack.com"];
	[nsNode5 addAttribute:[NSXMLNode attributeWithName:@"test" stringValue:@"5"]];
	
	[nsRoot addChild:nsNode1];
	[nsRoot addChild:nsNode2];
	[nsRoot addChild:nsNode3];
	[nsRoot addChild:nsNode4];
	[nsRoot addChild:nsNode5];
	
	DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"root"];
	[ddRoot addNamespace:[DDXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"]];
	[ddRoot addNamespace:[DDXMLNode namespaceWithName:@"b" stringValue:@"robbiehanson.com"]];
	
	DDXMLElement *ddNode1 = [DDXMLElement elementWithName:@"test"];
	[ddNode1 addAttribute:[DDXMLNode attributeWithName:@"test" stringValue:@"1"]];
	
	DDXMLElement *ddNode2 = [DDXMLElement elementWithName:@"a:test"];
	[ddNode2 addAttribute:[DDXMLNode attributeWithName:@"test" stringValue:@"2"]];
	
	DDXMLElement *ddNode3 = [DDXMLElement elementWithName:@"b:test"];
	[ddNode3 addAttribute:[DDXMLNode attributeWithName:@"test" stringValue:@"3"]];
	
	DDXMLElement *ddNode4 = [DDXMLElement elementWithName:@"test" URI:@"deusty.com"];
	[ddNode4 addAttribute:[DDXMLNode attributeWithName:@"test" stringValue:@"4"]];
	
	DDXMLElement *ddNode5 = [DDXMLElement elementWithName:@"test" URI:@"quack.com"];
	[ddNode5 addAttribute:[DDXMLNode attributeWithName:@"test" stringValue:@"5"]];
	
	[ddRoot addChild:ddNode1];
	[ddRoot addChild:ddNode2];
	[ddRoot addChild:ddNode3];
	[ddRoot addChild:ddNode4];
	[ddRoot addChild:ddNode5];
	
	NSString *nsTest1 = [[nsNode1 resolveNamespaceForName:[nsNode1 name]] stringValue];
	NSString *ddTest1 = [[ddNode1 resolveNamespaceForName:[ddNode1 name]] stringValue];
	
	STAssertTrue(!nsTest1 && !ddTest1, @"Failed test 1");
	
	NSString *nsTest2 = [[nsNode2 resolveNamespaceForName:[nsNode2 name]] stringValue];
	NSString *ddTest2 = [[ddNode2 resolveNamespaceForName:[ddNode2 name]] stringValue];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
	
	NSString *nsTest3 = [[nsNode3 resolveNamespaceForName:[nsNode3 name]] stringValue];
	NSString *ddTest3 = [[ddNode3 resolveNamespaceForName:[ddNode3 name]] stringValue];
	
	STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
	
	NSString *nsTest4 = [[nsNode4 resolveNamespaceForName:[nsNode4 name]] stringValue];
	NSString *ddTest4 = [[ddNode4 resolveNamespaceForName:[ddNode4 name]] stringValue];
	
	STAssertTrue(!nsTest4 && !ddTest4, @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
	
	NSString *nsTest5 = [nsNode4 resolvePrefixForNamespaceURI:@"deusty.com"];
	NSString *ddTest5 = [ddNode4 resolvePrefixForNamespaceURI:@"deusty.com"];
	
	STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
	
	NSString *nsTest6 = [nsNode4 resolvePrefixForNamespaceURI:@"robbiehanson.com"];
	NSString *ddTest6 = [ddNode4 resolvePrefixForNamespaceURI:@"robbiehanson.com"];
	
	STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
	
	NSString *nsTest7 = [nsNode4 resolvePrefixForNamespaceURI:@"quack.com"];
	NSString *ddTest7 = [ddNode4 resolvePrefixForNamespaceURI:@"quack.com"];
	
	STAssertTrue(!nsTest7 && !ddTest7, @"Failed test 7");
	
	NSString *nsTest8 = [nsNode4 resolvePrefixForNamespaceURI:nil];
	NSString *ddTest8 = [ddNode4 resolvePrefixForNamespaceURI:nil];
	
	STAssertTrue(!nsTest8 && !ddTest8, @"Failed test 8");
	
	NSUInteger nsTest9  = [[nsRoot elementsForName:@"test"] count];  // Returns test1, test4, test5
	NSUInteger ddTest9  = [[ddRoot elementsForName:@"test"] count];  // Returns test1, test4, test5
	
	STAssertTrue(nsTest9 == ddTest9, @"Failed test 9");
	
	NSUInteger nsTest10 = [[nsRoot elementsForName:@"a:test"] count];  // Returns node2 and node4
	NSUInteger ddTest10 = [[ddRoot elementsForName:@"a:test"] count];  // Returns node2 and node4
	
	STAssertTrue(nsTest10 == ddTest10, @"Failed test 10");
	
	NSUInteger nsTest11 = [[nsRoot elementsForLocalName:@"test" URI:@"deusty.com"] count];  // Returns node2 and node4
	NSUInteger ddTest11 = [[ddRoot elementsForLocalName:@"test" URI:@"deusty.com"] count];  // Returns node2 and node4
	
	STAssertTrue(nsTest11 == ddTest11, @"Failed test 11");
	
	NSUInteger nsTest12 = [[nsRoot elementsForLocalName:@"a:test" URI:@"deusty.com"] count];  // Returns nothing
	NSUInteger ddTest12 = [[ddRoot elementsForLocalName:@"a:test" URI:@"deusty.com"] count];  // Returns nothing
	
	STAssertTrue(nsTest12 == ddTest12, @"Failed test 12");
	
	NSUInteger nsTest13 = [[nsRoot elementsForLocalName:@"test" URI:@"quack.com"] count];  // Returns node5
	NSUInteger ddTest13 = [[ddRoot elementsForLocalName:@"test" URI:@"quack.com"] count];  // Returns node5
	
	STAssertTrue(nsTest13 == ddTest13, @"Failed test 13");
}

- (void)testXmlns
{
    NSString *parseMe = @"<query xmlns=\"jabber:iq:roster\"></query>";
	NSData *data = [parseMe dataUsingEncoding:NSUTF8StringEncoding];
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
	NSXMLElement *nsRootElement = [nsDoc rootElement];
	
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
	DDXMLElement *ddRootElement = [ddDoc rootElement];
	
	// Both URI and namespaceForPrefix:@"" should return "jabber:iq:roster"
	
	NSString *nsTest1 = [nsRootElement URI];
	NSString *ddTest1 = [ddRootElement URI];
	
	STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
	
	NSString *nsTest2 = [[nsRootElement namespaceForPrefix:@""] stringValue];
	NSString *ddTest2 = [[ddRootElement namespaceForPrefix:@""] stringValue];
	
	STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
	
	// In NSXML namespaceForPrefix:nil returns nil
	// In DDXML namespaceForPrefix:nil returns the same as namespaceForPrefix:@""
	//
	// This actually makes more sense, as many users would consider a prefix of nil or an empty string to be the same.
	// Plus many XML documents state that a prefix of nil or "" should be treated equally.
	//
	// This difference comes into play in other areas.
	//
	// In NSXML creating a namespace with prefix:nil doesn't work.
	// In DDXML creating a namespace with prefix:nil acts as if you had passed an empty string.
	
	NSUInteger nsTest3 = [[nsRootElement namespaces] count];
	NSUInteger ddTest3 = [[ddRootElement namespaces] count];
	
	STAssertTrue(nsTest3 == ddTest3, @"Failed test 3");
	
	// An odd quirk of NSXML is that if the data is parsed, then the namespaces array contains the default namespace.
	// However, if the XML tree is generated in code, and the default namespace was set via setting the URI,
	// then the namespaces array doesn't contain that default namespace.
	// If instead the addNamespace method is used to add the default namespace, then it is contained in the array,
	// and the URI is also properly set.
	//
	// I consider this to be a bug in NSXML.
	
	NSString *nsTest4 = [[nsRootElement resolveNamespaceForName:@""] stringValue];
	NSString *ddTest4 = [[ddRootElement resolveNamespaceForName:@""] stringValue];
	
	STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
	
	// Oddly enough, even though NSXML seems completely resistant to nil namespace prefixes, this works fine
	NSString *nsTest5 = [[nsRootElement resolveNamespaceForName:nil] stringValue];
	NSString *ddTest5 = [[ddRootElement resolveNamespaceForName:nil] stringValue];
	
	STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5");
	
	NSXMLElement *nsNode = [NSXMLElement elementWithName:@"query"];
	[nsNode addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"jabber:iq:auth"]];
	
	DDXMLElement *ddNode = [DDXMLElement elementWithName:@"query"];
	[ddNode addNamespace:[DDXMLNode namespaceWithName:@"" stringValue:@"jabber:iq:auth"]];
	
	NSString *nsTest6 = [[nsNode resolveNamespaceForName:@""] stringValue];
	NSString *ddTest6 = [[ddNode resolveNamespaceForName:@""] stringValue];
	
	STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
	
	NSString *nsTest7 = [[nsNode resolveNamespaceForName:nil] stringValue];
	NSString *ddTest7 = [[ddNode resolveNamespaceForName:nil] stringValue];
	
	STAssertTrue([nsTest7 isEqualToString:ddTest7], @"Failed test 7");
	
	NSString *nsTest8 = [nsNode URI];
	NSString *ddTest8 = [ddNode URI];
	
	STAssertTrue([nsTest8 isEqualToString:ddTest8], @"Failed test 8");
	
	NSUInteger nsTest9 = [[nsNode namespaces] count];
	NSUInteger ddTest9 = [[ddNode namespaces] count];
	
	STAssertTrue(nsTest9 == ddTest9, @"Failed test 9");
}

- (void)testCopy
{
    // <parent>
	//   <child age="4">Billy</child>
	// </parent>
	
	NSString *xmlStr = @"<parent><child age=\"4\">Billy</child></parent>";
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	// Test Document copy
	
	NSXMLDocument *nsDocCopy = [nsDoc copy];
	[[nsDocCopy rootElement] addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"mom"]];
	
	NSXMLNode *nsDocAttr = [[nsDoc rootElement] attributeForName:@"type"];
	NSXMLNode *nsDocCopyAttr = [[nsDocCopy rootElement] attributeForName:@"type"];
	
	STAssertTrue(nsDocAttr == nil, @"Failed CHECK 1");
	STAssertTrue(nsDocCopyAttr != nil, @"Failed CHECK 2");
	
	DDXMLDocument *ddDocCopy = [ddDoc copy];
	[[ddDocCopy rootElement] addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"mom"]];
	
	DDXMLNode *ddDocAttr = [[ddDoc rootElement] attributeForName:@"type"];
	DDXMLNode *ddDocCopyAttr = [[ddDocCopy rootElement] attributeForName:@"type"];
	
	STAssertTrue(ddDocAttr == nil, @"Failed test 1");
	STAssertTrue(ddDocCopyAttr != nil, @"Failed test 2");
	
	// Test Element copy
	
	NSXMLElement *nsElement = [[[nsDoc rootElement] elementsForName:@"child"] objectAtIndex:0];
	NSXMLElement *nsElementCopy = [nsElement copy];
	
	STAssertTrue([nsElement parent] != nil, @"Failed CHECK 3");
	STAssertTrue([nsElementCopy parent] == nil, @"Failed CHECK 4");
	
	[nsElementCopy addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"son"]];
	
	NSXMLNode *nsElementAttr = [nsElement attributeForName:@"type"];
	NSXMLNode *nsElementCopyAttr = [nsElementCopy attributeForName:@"type"];
	
	STAssertTrue(nsElementAttr == nil, @"Failed CHECK 5");
	STAssertTrue(nsElementCopyAttr != nil, @"Failed CHECK 6");
	
	DDXMLElement *ddElement = [[[ddDoc rootElement] elementsForName:@"child"] objectAtIndex:0];
	DDXMLElement *ddElementCopy = [ddElement copy];
    
	STAssertTrue([nsElement parent] != nil, @"Failed test 3");
	STAssertTrue([nsElementCopy parent] == nil, @"Failed test 4");
	
	[ddElementCopy addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"son"]];
	
	DDXMLNode *ddElementAttr = [ddElement attributeForName:@"type"];
	DDXMLNode *ddElementCopyAttr = [ddElementCopy attributeForName:@"type"];
	
	STAssertTrue(ddElementAttr == nil, @"Failed test 5");
	STAssertTrue(ddElementCopyAttr != nil, @"Failed test 6");
	
	// Test Node copy
	
	NSXMLNode *nsAttr = [nsElement attributeForName:@"age"];
	NSXMLNode *nsAttrCopy = [nsAttr copy];
	
	STAssertTrue([nsAttr parent] != nil, @"Failed CHECK 7");
	STAssertTrue([nsAttrCopy parent] == nil, @"Failed CHECK 8");
	
	[nsAttrCopy setStringValue:@"5"];
	
	NSString *nsAttrValue = [nsAttr stringValue];
	NSString *nsAttrCopyValue = [nsAttrCopy stringValue];
	
	STAssertTrue([nsAttrValue isEqualToString:@"4"], @"Failed CHECK 9");
	STAssertTrue([nsAttrCopyValue isEqualToString:@"5"], @"Failed CHECK 10");
	
	DDXMLNode *ddAttr = [ddElement attributeForName:@"age"];
	DDXMLNode *ddAttrCopy = [ddAttr copy];
	
	STAssertTrue([ddAttr parent] != nil, @"Failed test 7");
	STAssertTrue([ddAttrCopy parent] == nil, @"Failed test 8");
	
	[ddAttrCopy setStringValue:@"5"];
	
	NSString *ddAttrValue = [ddAttr stringValue];
	NSString *ddAttrCopyValue = [ddAttrCopy stringValue];
	
	STAssertTrue([ddAttrValue isEqualToString:@"4"], @"Failed test 9");
	STAssertTrue([ddAttrCopyValue isEqualToString:@"5"], @"Failed test 10");
}

- (void)testCData
{
    // <?xml version="1.0"?>
	// <request>
	//   <category>
	//     <name><![CDATA[asdfdsfafasdfsf]]></name>
	//     <type><![CDATA[post]]></type>
	//   </category>
	// </request>
	
	NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<request>"];
	[xmlStr appendString:@"  <category>"];
	[xmlStr appendString:@"    <name><![CDATA[asdfdsfafasdfsf]]></name>"];
	[xmlStr appendString:@"    <type><![CDATA[post]]></type>"];
	[xmlStr appendString:@"  </category>"];
	[xmlStr appendString:@"</request>"];
	
	NSError *nsErr = nil;
	NSError *ddErr = nil;
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&nsErr];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&ddErr];
	
	STAssertTrue(nsDoc != nil, @"Failed CHECK 1: %@", nsErr);
	STAssertTrue(ddDoc != nil, @"Failed test 1: %@", ddErr);
}

- (void)testElements
{
    NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<request>"];
	[xmlStr appendString:@"  <category>"];
	[xmlStr appendString:@"    <name>Jojo</name>"];
	[xmlStr appendString:@"    <type>Mama</type>"];
	[xmlStr appendString:@"  </category>"];
	[xmlStr appendString:@"</request>"];
	
	NSArray *children = nil;
	int i = 0;
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	children = [[nsDoc rootElement] children];
	for(i = 0; i < [children count]; i++)
	{
		NSXMLNode *child = [children objectAtIndex:i];
        
		if([child kind] == NSXMLElementKind)
		{
			STAssertTrue([child isMemberOfClass:[NSXMLElement class]], @"Failed CHECK 1");
		}
	}
	
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	children = [[ddDoc rootElement] children];
	for(i = 0; i < [children count]; i++)
	{
		DDXMLNode *child = [children objectAtIndex:i];
		
		if([child kind] == DDXMLElementKind)
		{
			STAssertTrue([child isMemberOfClass:[DDXMLElement class]], @"Failed test 1");
		}
	}
}

- (void)testXPath
{
    NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<menu xmlns=\"food.com\" xmlns:a=\"deusty.com\">"];
	[xmlStr appendString:@"  <salad>"];
	[xmlStr appendString:@"    <name>Ceasar</name>"];
	[xmlStr appendString:@"    <price>1.99</price>"];
	[xmlStr appendString:@"  </salad>"];
	[xmlStr appendString:@"  <pizza>"];
	[xmlStr appendString:@"    <name>Supreme</name>"];
	[xmlStr appendString:@"    <price>9.99</price>"];
	[xmlStr appendString:@"  </pizza>"];
	[xmlStr appendString:@"  <pizza>"];
	[xmlStr appendString:@"    <name>Three Cheese</name>"];
	[xmlStr appendString:@"    <price>7.99</price>"];
	[xmlStr appendString:@"  </pizza>"];
	[xmlStr appendString:@"  <beer tap=\"yes\"/>"];
	[xmlStr appendString:@"</menu>"];
	
	int i = 0;
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	NSXMLElement *nsMenu = [nsDoc rootElement];
	DDXMLElement *ddMenu = [ddDoc rootElement];
	
	NSString *nsDocXPath = [nsDoc XPath]; // empty string
	NSString *ddDocXPath = [ddDoc XPath]; // empty string
	
	STAssertTrue([nsDocXPath isEqualToString:ddDocXPath], @"Failed test 1");
	
	NSString *nsMenuXPath = [nsMenu XPath];
	NSString *ddMenuXPath = [ddMenu XPath];
	
	STAssertTrue([nsMenuXPath isEqualToString:ddMenuXPath], @"Failed test 2");
	
	NSArray *nsChildren = [nsMenu children];
	NSArray *ddChildren = [ddMenu children];
	
	STAssertTrue([nsChildren count] == [ddChildren count], @"Failed CHECK 1");
	
	for(i = 0; i < [nsChildren count]; i++)
	{
		NSString *nsChildXPath = [[nsChildren objectAtIndex:i] XPath];
		NSString *ddChildXPath = [[ddChildren objectAtIndex:i] XPath];
		
		STAssertTrue([nsChildXPath isEqualToString:ddChildXPath], @"Failed test 3");
	}
	
	NSXMLElement *nsBeer = [[nsMenu elementsForName:@"beer"] objectAtIndex:0];
	DDXMLElement *ddBeer = [[ddMenu elementsForName:@"beer"] objectAtIndex:0];
	
	NSArray *nsAttributes = [nsBeer attributes];
	NSArray *ddAttributes = [ddBeer attributes];
	
	STAssertTrue([nsAttributes count] == [ddAttributes count], @"Failed CHECK 2");
	
	for(i = 0; i < [nsAttributes count]; i++)
	{
		NSString *nsAttrXPath = [[nsAttributes objectAtIndex:i] XPath];
		NSString *ddAttrXPath = [[ddAttributes objectAtIndex:i] XPath];
		
		STAssertTrue([nsAttrXPath isEqualToString:ddAttrXPath],
				  @"Failed test 4: ns(%@) != dd(%@)", nsAttrXPath, ddAttrXPath);
	}
    
	NSArray *nsNamespaces = [nsMenu namespaces];
	NSArray *ddNamespaces = [ddMenu namespaces];
	
	STAssertTrue([nsNamespaces count] == [ddNamespaces count], @"Failed CHECK 3");
	
	for(i = 0; i < [nsNamespaces count]; i++)
	{
		NSString *nsNamespaceXPath = [[nsNamespaces objectAtIndex:i] XPath];
		NSString *ddNamespaceXPath = [[ddNamespaces objectAtIndex:i] XPath];
		
		STAssertTrue([nsNamespaceXPath isEqualToString:ddNamespaceXPath], @"Failed test 5 - ns(%@) dd(%@)",
                  nsNamespaceXPath, ddNamespaceXPath);
	}
	
	
	NSXMLElement *nsElement1 = [NSXMLElement elementWithName:@"duck"];
	NSXMLElement *nsElement2 = [NSXMLElement elementWithName:@"quack"];
	[nsElement1 addChild:nsElement2];
	
	DDXMLElement *ddElement1 = [DDXMLElement elementWithName:@"duck"];
	DDXMLElement *ddElement2 = [DDXMLElement elementWithName:@"quack"];
	[ddElement1 addChild:ddElement2];
	
	NSString *nsElement1XPath = [nsElement1 XPath];
	NSString *ddElement1XPath = [ddElement1 XPath];
	
	STAssertTrue([nsElement1XPath isEqualToString:ddElement1XPath],
			  @"Failed test 6: ns(%@) != dd(%@)", nsElement1XPath, ddElement1XPath);
	
	NSString *nsElement2XPath = [nsElement2 XPath];
	NSString *ddElement2XPath = [ddElement2 XPath];
	
	STAssertTrue([nsElement2XPath isEqualToString:ddElement2XPath],
	          @"Failed test 7: ns(%@) != dd(%@)", nsElement2XPath, ddElement2XPath);
	
	NSXMLNode *nsAttr = [NSXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
	NSXMLNode *ddAttr = [DDXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
	
	NSString *nsAttrXPath = [nsAttr XPath];
	NSString *ddAttrXPath = [ddAttr XPath];
	
	STAssertTrue([nsAttrXPath isEqualToString:ddAttrXPath],
			  @"Failed test 8: ns(%@) != dd(%@)", nsAttrXPath, ddAttrXPath);
}

- (void)testNodesForXPath
{
    NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<menu xmlns:a=\"tap\">"];
	[xmlStr appendString:@"  <salad>"];
	[xmlStr appendString:@"    <name>Ceasar</name>"];
	[xmlStr appendString:@"    <price>1.99</price>"];
	[xmlStr appendString:@"  </salad>"];
	[xmlStr appendString:@"  <pizza>"];
	[xmlStr appendString:@"    <name>Supreme</name>"];
	[xmlStr appendString:@"    <price>9.99</price>"];
	[xmlStr appendString:@"  </pizza>"];
	[xmlStr appendString:@"  <pizza>"];
	[xmlStr appendString:@"    <name>Three Cheese</name>"];
	[xmlStr appendString:@"    <price>7.99</price>"];
	[xmlStr appendString:@"  </pizza>"];
	[xmlStr appendString:@"  <a:beer delicious=\"yes\"/>"];
	[xmlStr appendString:@"</menu>"];
	
	NSError *err = nil;
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	NSArray *nsTest0 = [nsDoc nodesForXPath:@"/menu/b:salad[1]" error:&err];
	
	STAssertTrue(nsTest0 == nil, @"Failed CHECK 1");
	STAssertTrue(err != nil, @"Failed CHECK 2");
	
	NSArray *nsTest1 = [nsDoc nodesForXPath:@"/menu/salad[1]" error:&err];
	
	STAssertTrue(err == nil, @"Failed CHECK 3");
	
	NSArray *ddTest0 = [ddDoc nodesForXPath:@"/menu/b:salad[1]" error:&err];
	
	STAssertTrue(ddTest0 == nil, @"Failed test 1");
	STAssertTrue(err != nil, @"Failed test 2");
	
	NSArray *ddTest1 = [ddDoc nodesForXPath:@"/menu/salad[1]" error:&err];
	
	STAssertTrue(err == nil, @"Failed test 3");
	
	STAssertTrue([nsTest1 count] == [ddTest1 count], @"Failed test 4");
	
	NSArray *nsTest2 = [nsDoc nodesForXPath:@"menu/pizza" error:&err];
	NSArray *ddTest2 = [ddDoc nodesForXPath:@"menu/pizza" error:&err];
	
	STAssertTrue([nsTest2 count] == [ddTest2 count], @"Failed test 5");
	
	NSArray *nsTest3 = [nsDoc nodesForXPath:@"menu/a:beer/@delicious" error:&err];
	NSArray *ddTest3 = [ddDoc nodesForXPath:@"menu/a:beer/@delicious" error:&err];
	
	STAssertTrue([nsTest3 count] == [ddTest3 count], @"Failed test 6");
	
	NSString *nsYes = [[nsTest3 objectAtIndex:0] stringValue];
	NSString *ddYes = [[ddTest3 objectAtIndex:0] stringValue];
	
	STAssertTrue([nsYes isEqualToString:ddYes], @"Failed test 7");
	
	
	NSXMLElement *nsElement1 = [NSXMLElement elementWithName:@"duck"];
	NSXMLElement *nsElement2 = [NSXMLElement elementWithName:@"quack"];
	[nsElement1 addChild:nsElement2];
	
	DDXMLElement *ddElement1 = [DDXMLElement elementWithName:@"duck"];
	DDXMLElement *ddElement2 = [DDXMLElement elementWithName:@"quack"];
	[ddElement1 addChild:ddElement2];
	
	NSArray *nsTest4 = [nsElement1 nodesForXPath:@"quack[1]" error:nil];
	NSArray *ddTest4 = [ddElement1 nodesForXPath:@"quack[1]" error:nil];
	
	STAssertTrue([nsTest4 count] == [ddTest4 count], @"Failed test 8");
}

- (void)testNSXMLBugs
{
    // <query xmlns="jabber:iq:private">
	//   <x xmlns="some:other:namespace"></x>
	// </query>
	
	NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
	[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
	[xmlStr appendString:@"<query xmlns=\"jabber:iq:private\">"];
	[xmlStr appendString:@"  <x xmlns=\"some:other:namespace\"></x>"];
	[xmlStr appendString:@"</query>"];
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
	
	NSArray *nsChildren = [[nsDoc rootElement] elementsForName:@"x"];
	NSArray *ddChildren = [[ddDoc rootElement] elementsForName:@"x"];
	
	if([nsChildren count] > 0)
	{
		NSLog(@"Good news: Apple finally fixed that elementsForName: bug!");
	}
	
	STAssertTrue([ddChildren count] == 1, @"Failed test 1");
}

- (void)testInsertChild
{
    NSXMLElement *nsParent = [NSXMLElement elementWithName:@"parent"];
	DDXMLElement *ddParent = [DDXMLElement elementWithName:@"parent"];
	
	NSXMLElement *nsChild2 = [NSXMLElement elementWithName:@"child2"];
	DDXMLElement *ddChild2 = [DDXMLElement elementWithName:@"child2"];
	
	[nsParent insertChild:nsChild2 atIndex:0];
	[ddParent insertChild:ddChild2 atIndex:0];
	
	STAssertTrue([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 1");
	
	NSXMLElement *nsChild0 = [NSXMLElement elementWithName:@"child0"];
	DDXMLElement *ddChild0 = [DDXMLElement elementWithName:@"child0"];
	
	[nsParent insertChild:nsChild0 atIndex:0];
	[ddParent insertChild:ddChild0 atIndex:0];
	
	STAssertTrue([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 2");
	
	NSXMLElement *nsChild1 = [NSXMLElement elementWithName:@"child1"];
	DDXMLElement *ddChild1 = [DDXMLElement elementWithName:@"child1"];
	
	[nsParent insertChild:nsChild1 atIndex:1];
	[ddParent insertChild:ddChild1 atIndex:1];
	
	STAssertTrue([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 3");
	
	NSXMLElement *nsChild3 = [NSXMLElement elementWithName:@"child3"];
	DDXMLElement *ddChild3 = [DDXMLElement elementWithName:@"child3"];
	
	[nsParent insertChild:nsChild3 atIndex:3];
	[ddParent insertChild:ddChild3 atIndex:3];
	
	STAssertTrue([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 4");
	
	NSXMLElement *nsChild5 = [NSXMLElement elementWithName:@"child5"];
	DDXMLElement *ddChild5 = [DDXMLElement elementWithName:@"child5"];
	
    STAssertThrows([nsParent insertChild:nsChild5 atIndex:5], @"Exception - index (5) beyond bounds (5)");
    STAssertThrows([ddParent insertChild:ddChild5 atIndex:5], @"Exception - index (5) beyond bounds (5)");
}

- (void)testElementSerialization
{
    NSString *str = @"<soup spicy=\"no\">chicken noodle</soup>";
	NSError *err;
	
	err = nil;
	NSXMLElement *nse = [[NSXMLElement alloc] initWithXMLString:str error:&err];
	
	STAssertTrue((nse != nil) && (err == nil), @"Failed CHECK 1");
	
	err = nil;
	DDXMLElement *dde = [[DDXMLElement alloc] initWithXMLString:str error:&err];
	
	STAssertTrue((dde != nil) && (err == nil), @"Failed test 1");
	
	STAssertTrue([[nse XMLString] isEqualToString:[dde XMLString]], @"Failed test 2");
}

- (void)testAttrWithColonInName
{
    NSString *str = @"<artist name='Jay-Z' xml:pimp='yes' />";
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithXMLString:str options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithXMLString:str options:0 error:nil];
	
	NSXMLNode *nsa = [[nsDoc rootElement] attributeForName:@"xml:pimp"];
	DDXMLNode *dda = [[ddDoc rootElement] attributeForName:@"xml:pimp"];
	
	STAssertTrue(nsa != nil, @"Failed CHECK 1");
	STAssertTrue(dda != nil, @"Failed test 1");
}

- (void)testAttrNs
{
    NSString *nsName, *ddName;
	NSString *nsUri, *ddUri;
	
	// 1. Normal attribute: duck='quack'.
	//    Then try setting the URI of the attribute.
	
	NSXMLNode *nsAttr1 = [NSXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	DDXMLNode *ddAttr1 = [DDXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	
	nsName = [nsAttr1 name];
	ddName = [ddAttr1 name];
	
	nsUri = [nsAttr1 URI];
	ddUri = [ddAttr1 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 1A");
	STAssertTrue(nsUri == nil && ddUri == nil, @"Failed test 1B");
	
	[nsAttr1 setURI:@"http://animal.com"];
	[ddAttr1 setURI:@"http://animal.com"];
	
	nsName = [nsAttr1 name];
	ddName = [ddAttr1 name];
	
	nsUri = [nsAttr1 URI];
	ddUri = [ddAttr1 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 1C");
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 1D");
	
	// 2. Try setting the URI of the attribute at creation time
	
	NSXMLNode *nsAttr2 = [NSXMLNode attributeWithName:@"duck" URI:@"http://animal.com" stringValue:@"quack"];
	DDXMLNode *ddAttr2 = [DDXMLNode attributeWithName:@"duck" URI:@"http://animal.com" stringValue:@"quack"];
	
	nsName = [nsAttr2 name];
	ddName = [ddAttr2 name];
	
	nsUri = [nsAttr2 URI];
	ddUri = [ddAttr2 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 2A");
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 2B");
	
	// 3. Try creating an attribute with a prefix but no URI (ns prefix, but no ns href)
	
	NSXMLNode *nsAttr3 = [NSXMLNode attributeWithName:@"animal:duck" stringValue:@"quack"];
	DDXMLNode *ddAttr3 = [DDXMLNode attributeWithName:@"animal:duck" stringValue:@"quack"];
	
	nsName = [nsAttr3 name];
	ddName = [ddAttr3 name];
	
	nsUri = [nsAttr3 URI];
	ddUri = [ddAttr3 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 3A");
	STAssertTrue(nsUri == nil && ddUri == nil, @"Failed test 3B");
	
	// 4. Try creating an attribute with a prefix and URI
	
	NSXMLNode *nsAttr4 = [NSXMLNode attributeWithName:@"animal:duck" URI:@"http://animal.com" stringValue:@"quack"];
	DDXMLNode *ddAttr4 = [DDXMLNode attributeWithName:@"animal:duck" URI:@"http://animal.com" stringValue:@"quack"];
	
	nsName = [nsAttr4 name];
	ddName = [ddAttr4 name];
	
	nsUri = [nsAttr4 URI];
	ddUri = [ddAttr4 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 4A");
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 4B");
	
	// Prep for next 2 tests
	//
	// <zoo xmlns:animan='animal.com' />
	
	NSXMLElement *nsElement = [NSXMLElement elementWithName:@"zoo"];
	[nsElement addNamespace:[NSXMLNode namespaceWithName:@"animal" stringValue:@"animal.com"]];
	
	DDXMLElement *ddElement = [DDXMLElement elementWithName:@"zoo"];
	[ddElement addNamespace:[DDXMLNode namespaceWithName:@"animal" stringValue:@"animal.com"]];
	
	// 5. Try adding an attribute with a prefix to an element with specifies the href for the prefix
	
	NSXMLNode *nsAttr5 = [NSXMLNode attributeWithName:@"animal:duck" stringValue:@"quack"];
	DDXMLNode *ddAttr5 = [DDXMLNode attributeWithName:@"animal:duck" stringValue:@"quack"];
	
	[nsElement addAttribute:nsAttr5];
	[ddElement addAttribute:ddAttr5];
	
	nsName = [nsAttr5 name];
	ddName = [ddAttr5 name];
	
	nsUri = [nsAttr5 URI];
	ddUri = [ddAttr5 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 5A");
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 5B - ns(%@) dd(%@)", nsUri, ddUri);
	
	// 6. Try adding an attribute with a URI to an element which specifies the prefix for the URI
	
	NSXMLNode *nsAttr6 = [NSXMLNode attributeWithName:@"duck" URI:@"animal.com" stringValue:@"quack"];
	DDXMLNode *ddAttr6 = [DDXMLNode attributeWithName:@"duck" URI:@"animal.com" stringValue:@"quack"];
	
	[nsElement addAttribute:nsAttr6];
	[ddElement addAttribute:ddAttr6];
	
	nsName = [nsAttr6 name];
	ddName = [ddAttr6 name];
	
	nsUri = [nsAttr6 URI];
	ddUri = [ddAttr6 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 6A - ns(%@) dd(%@)", nsName, ddName);
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 6B - ns(%@) dd(%@)", nsUri, ddUri);
	
	// 7. Try when there are default namespaces involved
	//
	// <zoo xmlns='farm.com'>
	//   <animal xmlns='animals.com' duck='quack'/>
	// </zoo>
	
	NSXMLElement *nsZoo = [NSXMLElement elementWithName:@"zoo" URI:@"zoo.com"];
	DDXMLElement *ddZoo = [DDXMLElement elementWithName:@"zoo" URI:@"zoo.com"];
	
	NSXMLElement *nsAnimal = [NSXMLElement elementWithName:@"animal" URI:@"animals.com"];
	DDXMLElement *ddAnimal = [DDXMLElement elementWithName:@"animal" URI:@"animals.com"];
	
	[nsZoo addChild:nsAnimal];
	[ddZoo addChild:ddAnimal];
	
	NSXMLNode *nsAttr7 = [NSXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	DDXMLNode *ddAttr7 = [DDXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	
	[nsAnimal addAttribute:nsAttr7];
	[ddAnimal addAttribute:ddAttr7];
	
	nsName = [nsAttr7 name];
	ddName = [ddAttr7 name];
	
	nsUri = [nsAttr7 URI];
	ddUri = [ddAttr7 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 7A");
	STAssertTrue(nsUri == nil && ddUri == nil, @"Failed test 7B");
	
	// 8. Try with the xml prefix
	//
	// <farm xml:duck='quack'/>
	
	NSXMLElement *nsFarm = [NSXMLElement elementWithName:@"farm"];
	DDXMLElement *ddFarm = [DDXMLElement elementWithName:@"farm"];
	
	NSXMLNode *nsAttr8 = [NSXMLNode attributeWithName:@"xml:duck" stringValue:@"quack"];
	DDXMLNode *ddAttr8 = [DDXMLNode attributeWithName:@"xml:duck" stringValue:@"quack"];
	
	[nsFarm addAttribute:nsAttr8];
	[ddFarm addAttribute:ddAttr8];
	
	nsName = [nsAttr8 name];
	ddName = [ddAttr8 name];
	
	nsUri = [nsAttr8 URI];
	ddUri = [ddAttr8 URI];
	
	STAssertTrue([nsName isEqualToString:ddName], @"Failed test 8A");
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 8B - ns(%@) dd(%@)", nsUri, ddUri);
}

- (void)testNsDetatchCopy
{
    NSString *nsUri;
	NSString *ddUri;
	
	// Test 1 - Set a URI on a standalone attribute
	
	NSXMLNode *nsAttr = [NSXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	DDXMLNode *ddAttr = [DDXMLNode attributeWithName:@"duck" stringValue:@"quack"];
	
	[nsAttr setURI:@"zoo.com"];
	[ddAttr setURI:@"zoo.com"];
	
	nsUri = [nsAttr URI];
	ddUri = [ddAttr URI];
	
	NSAssert([nsUri isEqualToString:ddUri], @"Failed test 1 - ns(%@) dd(%@)", nsUri, ddUri);
	
	// Test 2 - Strip a URI from a doc
	//
	// <animals xmlns:farm='animals:farm' xmlns:zoo='animals:zoo'>
	//   <farm:animal name='cow' />
	//   <zoo:animal name='lion' />
	// </animal>
	
	NSString *str = @"<animals xmlns:farm='animals:farm' xmlns:zoo='animals:zoo' farm:loc='CA' zoo:loc='MO' >\n"
    @"  <farm:animal name='cow' />\n"
    @"  <zoo:animal name='lion' />\n"
    @"</animals>";
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	
	NSXMLDocument *nsDoc = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
	DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
	
	NSXMLElement *nsRoot = [nsDoc rootElement];
	DDXMLElement *ddRoot = [ddDoc rootElement];
	
	NSXMLElement *nsCow = [[nsRoot elementsForName:@"farm:animal"] objectAtIndex:0];
	DDXMLElement *ddCow = [[ddRoot elementsForName:@"farm:animal"] objectAtIndex:0];
	
	nsUri = [nsCow URI];
	ddUri = [ddCow URI];
	
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 2a");
	
	[nsRoot removeNamespaceForPrefix:@"farm"];
	[ddRoot removeNamespaceForPrefix:@"farm"];
	
	nsUri = [nsCow URI];
	ddUri = [ddCow URI];
	
	STAssertTrue([nsUri isEqualToString:ddUri], @"Failed test 2b");
}

- (void)testInvalidNode
{
    NSXMLNode *nsNode = [[NSXMLNode alloc] init];
	DDXMLNode *ddNode = [[DDXMLNode alloc] init];
	
	STAssertTrue([NSStringFromClass([ddNode class]) isEqualToString:@"DDXMLInvalidNode"], @"Failed test 0");
	
	STAssertTrue([nsNode kind] == NSXMLInvalidKind, @"Failed CHECK 1a");
	STAssertTrue([ddNode kind] == DDXMLInvalidKind, @"Failed test 1a");
	
	NSString *nsName = [nsNode name];
	NSString *ddName = [ddNode name];
	
	STAssertTrue(nsName == nil && ddName == nil, @"Failed test 2 - ns(%@) dd(%@)", nsName, ddName);
	
	NSString *nsDesc = [nsNode description];
	NSString *ddDesc = [ddNode description];
	
	STAssertTrue(nsDesc && [nsDesc isEqualToString:ddDesc], @"Failed test 3 - ns(%@) dd(%@)", nsDesc, ddDesc);
}

@end
