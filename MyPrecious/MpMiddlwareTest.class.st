Class {
	#name : #MpMiddlwareTest,
	#superclass : #TestCase,
	#instVars : [
		'middlewareA',
		'middlewareB',
		'middlewareC',
		'proxyOfAInC'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpMiddlwareTest >> assertIsProxy: anObject [
		self assert: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlwareTest >> denyIsProxy: anObject [
		self deny: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlwareTest >> isProxy: anObject [
	^anObject actualClass includesBehavior: MpProxy

]

{ #category : #tests }
MpMiddlwareTest >> middlewareClass [
	^ MpMiddlewareForTest
]

{ #category : #tests }
MpMiddlwareTest >> newValueHolder [
	^ ValueHolder new
]

{ #category : #tests }
MpMiddlwareTest >> passByCopyObjects [
	^{'Hello Pharo'. 958. 3.14. false. true. nil. $a. 3/2} 
]

{ #category : #tests }
MpMiddlwareTest >> passByReferenceObjects [
	^{Object new. Class. #(). Set new. [1+2]}
]

{ #category : #tests }
MpMiddlwareTest >> setUp [
	super setUp.
	middlewareA := 	self middlewareClass new.
	middlewareB := 	self middlewareClass new.
	middlewareC := 	self middlewareClass new.

]

{ #category : #tests }
MpMiddlwareTest >> testArgPassByCopy [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self passByCopyObjects do: [ : arg |
		proxy contents: arg.
		self denyIsProxy: valueHolder contents. 
		self assert: valueHolder contents equals: arg]
	

]

{ #category : #tests }
MpMiddlwareTest >> testArgPassByReference [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self passByReferenceObjects do: [ : arg |
		proxy contents: arg.
		self assertIsProxy: valueHolder contents.
		self assert: valueHolder contents == valueHolder contents.
		self deny: valueHolder contents == proxy]
	

]

{ #category : #tests }
MpMiddlwareTest >> testArgProxyToObjectInThirdMiddleware [
	| a refA proxyAInB c refC proxyCInB proxyCInA |
	a := self newValueHolder.
	refA := middlewareA export: a.
	proxyAInB := middlewareB proxyTo: refA.
	c := self newValueHolder.
	refC := middlewareC export: c.
	proxyCInB := middlewareB proxyTo: refC.
	proxyAInB contents: proxyCInB.
	proxyCInA := a contents.
	self assertIsProxy: proxyCInA.
	self deny: proxyCInA == proxyCInB.
	self passByCopyObjects do: [ : arg |
		proxyCInA contents: arg.
		self assert: c contents equals: arg]
	
]

{ #category : #tests }
MpMiddlwareTest >> testException [
	| remoteReference proxy |
	remoteReference := middlewareA export: Object new.
	proxy := middlewareB proxyTo: remoteReference.
	self should: [proxy foo] raise: MpRemoteException
]

{ #category : #tests }
MpMiddlwareTest >> testProxyCreatedOnDemand [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlwareTest >> testProxyCreatedOnlyOnce [
	| remoteReference proxy1 proxy2 |
	remoteReference := middlewareA export: self newValueHolder.
	proxy1 := middlewareB proxyTo: remoteReference.
	proxy2 := middlewareB proxyTo: remoteReference.
	self assert: proxy1 == proxy2.
	
]

{ #category : #tests }
MpMiddlwareTest >> testProxyCreatedWithGivenId [
	| remoteReference proxy id |
	id := #someUniqueID.
	middlewareA export: self newValueHolder id: id.
	remoteReference := MpRemoteReference new
		objectId: id;
		yourself.
	proxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlwareTest >> testProxyOnBlock [
	| remoteReference proxy |
	remoteReference := middlewareA export: [1+2].
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy value equals: 3
]

{ #category : #tests }
MpMiddlwareTest >> testProxyOnClass [
	| remoteReference classProxy instanceProxy otherRemoteRef otherClassProxy |
	remoteReference := middlewareA export: Object.
	classProxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: classProxy.
	instanceProxy := classProxy new.
	self assertIsProxy: instanceProxy.
	self assert: (instanceProxy isKindOf: classProxy).
	otherRemoteRef := middlewareA export: Array.
	otherClassProxy := middlewareB proxyTo: otherRemoteRef.
	self deny: classProxy == otherClassProxy
]

{ #category : #tests }
MpMiddlwareTest >> testProxyYourself [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy yourself == proxy
]

{ #category : #tests }
MpMiddlwareTest >> testResultPassByCopy [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self passByCopyObjects do: [ : arg |
		valueHolder contents: arg.
		self denyIsProxy: proxy contents. 
		self assert: proxy contents equals: arg]

]

{ #category : #tests }
MpMiddlwareTest >> testResultPassByReference [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self passByReferenceObjects do: [ : arg |
		valueHolder contents: arg.
		self assertIsProxy: proxy contents.
		self assert: proxy contents == proxy contents.
		self deny: proxy contents == proxy]

]

{ #category : #tests }
MpMiddlwareTest >> testResultProxyToObjectInThirdMiddleware [
	| a refA proxyAInB c refC proxyCInB proxyCInA |
	a := self newValueHolder.
	refA := middlewareA export: a.
	proxyAInB := middlewareB proxyTo: refA.
	c := self newValueHolder.
	refC := middlewareC export: c.
	proxyCInA := middlewareA proxyTo: refC.
	a contents: proxyCInA.
	proxyCInB := proxyAInB contents.
	self assertIsProxy: proxyCInB.
	self deny: proxyAInB == proxyCInB.
	self passByCopyObjects do: [ : arg |
		proxyCInB contents: arg.
		self assert: c contents equals: arg]
	
]
