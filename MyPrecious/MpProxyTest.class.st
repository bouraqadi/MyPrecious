Class {
	#name : #MpProxyTest,
	#superclass : #TestCase,
	#instVars : [
		'channel',
		'proxy'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpProxyTest >> proxyClass [
	^MpProxy
]

{ #category : #tests }
MpProxyTest >> setUp [
	super setUp.
	channel := MpChannelMock new.
	proxy := self proxyClass channel: channel remoteReference: nil
]

{ #category : #tests }
MpProxyTest >> testMessageWithExceptionResponse [
	channel 
		selector: #class answer: Object;
		selector: #foo answer: [ Halt signal ];
		selector: #bar answer: [ZeroDivide signal];
		selector: #universal answer: 42.
	self assert: proxy class == Object.
	self should: [proxy foo] raise: Halt.
	self assert: proxy class == Object.
	self should: [proxy bar] raise: ZeroDivide.
	self assert: proxy class == self proxyClass.
	proxy universal.
	self assert: proxy class == Object.
	
]

{ #category : #tests }
MpProxyTest >> testMessageWithNormalResponse [
	channel 
		selector: #class answer: Object;
		selector: #foo answer: 123;
		selector: #bar answer: true.
	self assert: proxy foo equals: 123.
	self assert: proxy class == Object.
	self assert: proxy bar equals: true.
	self assert: proxy class == Object.

]

{ #category : #tests }
MpProxyTest >> testUnknownMessage [
	channel 
		selector: #class answer: Object;
		selector: #bar answer: 42.
	self assert: proxy class == Object.
	self should: [ proxy foo ] raise: MessageNotUnderstood.
	self assert: proxy class == self proxyClass.
	proxy bar.
	self assert: proxy class == Object.
	
]
