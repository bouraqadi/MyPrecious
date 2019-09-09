Class {
	#name : #MpMiddlewareTest,
	#superclass : #TestCase,
	#traits : 'CcTConcurrencyTest + CcTWaitPolling',
	#classTraits : 'CcTConcurrencyTest classTrait + CcTWaitPolling classTrait',
	#instVars : [
		'middlewareA',
		'middlewareB',
		'middlewareC',
		'initialServices'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpMiddlewareTest >> allMiddleware [
	^{ middlewareA . middlewareB . middlewareC }
]

{ #category : #tests }
MpMiddlewareTest >> assertIsProxy: anObject [
		self assert: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlewareTest >> denyIsProxy: anObject [
		self deny: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlewareTest >> isProxy: anObject [
	"We cannot rely on the class messare or messages that use it such as isKindOf:"
	"This is proxies are supposed to capture all message including class"
	| actualClass |
	actualClass := (ProtoObject compiledMethodAt: #class) valueWithReceiver: anObject arguments: #().
	^actualClass includesBehavior: MpProxy

]

{ #category : #tests }
MpMiddlewareTest >> middlewareClass [
	^ MpMiddlewareForTest
]

{ #category : #tests }
MpMiddlewareTest >> newValueHolder [
	^ ValueHolder new
]

{ #category : #tests }
MpMiddlewareTest >> passByCopyObjects [
	^{'Hello Pharo'. 958. 3.14. false. true. nil. $a. 3/2} 
]

{ #category : #tests }
MpMiddlewareTest >> passByReferenceObjects [
	^{Object new. Class. #(). Set new. [1+2]}
]

{ #category : #tests }
MpMiddlewareTest >> runCaseManaged [
	"We don't want SUnit terminate our processes, because it makes debugging difficult. 
	We want to see currently active processes/services while debugging failures.
	Our setup/tearDown deal with clean up."
	self runCase
]

{ #category : #tests }
MpMiddlewareTest >> setUp [
	super setUp.
	initialServices := CcService allInstances.
	middlewareA := 	self middlewareClass new.
	middlewareB := 	self middlewareClass new.
	middlewareC := 	self middlewareClass new.

]

{ #category : #tests }
MpMiddlewareTest >> tearDown [
	| newServices |
	super tearDown.
	newServices := CcService allInstances copyWithoutAll: initialServices.
	newServices do: #stop
]

{ #category : #tests }
MpMiddlewareTest >> testArgPassByCopy [
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
MpMiddlewareTest >> testArgPassByReference [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self passByReferenceObjects do: [ : arg |
		proxy contents: arg.
		self assertIsProxy: valueHolder contents.
		self deny: valueHolder contents == arg.
		self deny: valueHolder contents == proxy]
	

]

{ #category : #tests }
MpMiddlewareTest >> testArgProxyToObjectInThirdMiddleware [
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
MpMiddlewareTest >> testException [
	| remoteReference proxy |
	remoteReference := middlewareA export: Object new.
	proxy := middlewareB proxyTo: remoteReference.
	self should: [proxy foo] raise: MpRemoteException
]

{ #category : #tests }
MpMiddlewareTest >> testInboundChannelReceiveObject [
	| remoteReferenceA inboundChannelA message total |
	total := 0.
	remoteReferenceA := middlewareA export: [: x | total := x + total].
	middlewareB outboundChannelTo: remoteReferenceA.
	self waitUntil: [middlewareA inboundChannels size = 1] timeout: 100 milliSeconds.
	inboundChannelA := middlewareA inboundChannels anyOne. 
	message := MpRemoteMessage
		selector: #value:
		arguments: #(2)
		receiver: remoteReferenceA 
		responseId: #any.
	inboundChannelA receiveObject: message.
	self assert: total equals: 2.
]

{ #category : #tests }
MpMiddlewareTest >> testOutboundChannelSendMessageNoWait [
	| remoteReferenceA message outboundChannelB proxyB total|
	total := 0.
	remoteReferenceA := middlewareA export: [: x | total := x + total].
	proxyB := middlewareB proxyTo: remoteReferenceA.
	message := Message
		selector: #value:
		arguments: #(2).
	outboundChannelB := middlewareB outboundChannelTo: remoteReferenceA.
	outboundChannelB sendMessageNoWait: message to: proxyB responseId: #any.
	self waitUntil: [total = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedOnDemand [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedOnlyOnce [
	| remoteReference proxy1 proxy2 |
	remoteReference := middlewareA export: self newValueHolder.
	proxy1 := middlewareB proxyTo: remoteReference.
	proxy2 := middlewareB proxyTo: remoteReference.
	self assert: proxy1 == proxy2.
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedWithGivenId [
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
MpMiddlewareTest >> testProxyOnBlock [
	| remoteReference proxy |
	remoteReference := middlewareA export: [1+2].
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy value equals: 3
]

{ #category : #tests }
MpMiddlewareTest >> testProxyOnClass [
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
MpMiddlewareTest >> testProxyYourself [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy yourself == proxy
]

{ #category : #tests }
MpMiddlewareTest >> testResultPassByCopy [
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
MpMiddlewareTest >> testResultPassByReference [
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
MpMiddlewareTest >> testResultProxyToObjectInThirdMiddleware [
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

{ #category : #tests }
MpMiddlewareTest >> testTimeoutRemoteMessage [
	| proxy remoteReference infiniteWaitSemaphore doneSemaphore isTimeout |
	infiniteWaitSemaphore := Semaphore new.
	doneSemaphore := Semaphore new.
	remoteReference := middlewareA export: infiniteWaitSemaphore.
	proxy := middlewareB proxyTo: remoteReference.
	isTimeout := false.
	[ 
		[proxy wait] on: CcPromiseTimeout do: [: ex | isTimeout := true].
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinMilliseconds: 200.
	self assert: isTimeout

]
