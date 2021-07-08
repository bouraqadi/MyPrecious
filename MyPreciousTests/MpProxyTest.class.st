Class {
	#name : #MpProxyTest,
	#superclass : #TestCase,
	#instVars : [
		'proxy',
		'transporter'
	],
	#category : #'MyPreciousTests-Common'
}

{ #category : #tests }
MpProxyTest >> proxyClass [
	^MpProxy
]

{ #category : #tests }
MpProxyTest >> setUp [

	| someReference |
	super setUp.
	transporter := MpTransporterMock new.
	someReference := MpRemoteReference basicNew.
	proxy := self proxyClass
		         transporter: transporter
		         remoteReference: someReference
]

{ #category : #tests }
MpProxyTest >> testMessageWithExceptionResponse [

	transporter
		selector: #class answer: Object;
		selector: #className answer: 'Object';
		selector: #foo answer: [ Halt signal ];
		selector: #bar answer: [ ZeroDivide signal ];
		selector: #universal answer: 42.
	self assert: proxy class identicalTo: Object.
	self should: [ proxy foo ] raise: Halt.
	self assert: proxy class identicalTo: Object.
	self should: [ proxy bar ] raise: ZeroDivide.
	self assert: proxy class == self proxyClass.
	proxy universal.
	self assert: proxy class == Object
]

{ #category : #tests }
MpProxyTest >> testMessageWithNormalResponse [

	transporter
		selector: #class answer: Object;
		selector: #className answer: 'Object';
		selector: #foo answer: 123;
		selector: #bar answer: true.
	self assert: proxy foo equals: 123.
	self assert: proxy class identicalTo: Object.
	self assert: proxy bar equals: true.
	self assert: proxy class identicalTo: Object
]

{ #category : #tests }
MpProxyTest >> testUnknownMessage [

	transporter
		selector: #class answer: Object;
		selector: #className answer: 'Object';
		selector: #bar answer: 42.
	self assert: proxy class identicalTo: Object.
	self should: [ proxy foo ] raise: MessageNotUnderstood.
	self assert: proxy class identicalTo: self proxyClass.
	proxy bar.
	self assert: proxy class identicalTo: Object
]
