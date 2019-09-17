Class {
	#name : #MpMiddlewareTestOLD,
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
MpMiddlewareTestOLD >> passByCopyObjects [
	^{'Hello Pharo'. 958. 3.14. false. true. nil. $a. 3/2} 
]

{ #category : #tests }
MpMiddlewareTestOLD >> passByReferenceObjects [
	^{Object new. Class. #(). Set new. [1+2]}
]

{ #category : #tests }
MpMiddlewareTestOLD >> runCaseManaged [
	"We don't want SUnit terminate our processes, because it makes debugging difficult. 
	We want to see currently active processes/services while debugging failures.
	Our setup/tearDown deal with clean up."
	self runCase

]

{ #category : #tests }
MpMiddlewareTestOLD >> setUp [
	super setUp.
	initialServices := CcService allInstances.
	middlewareA := 	self middlewareClass new.
	middlewareB := 	self middlewareClass new.
	middlewareC := 	self middlewareClass new.

]

{ #category : #tests }
MpMiddlewareTestOLD >> tearDown [
	| newServices |
	super tearDown.
	newServices := CcService allInstances copyWithoutAll: initialServices.
	newServices do: #stop
]

{ #category : #tests }
MpMiddlewareTestOLD >> testArgPassByCopy [
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
MpMiddlewareTestOLD >> testArgPassByReference [
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
MpMiddlewareTestOLD >> testArgProxyToObjectInThirdMiddleware [
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
MpMiddlewareTestOLD >> testChannelsCreation [
	| valueHolderA remoteReferenceA proxyB |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	self assert: middlewareA inboundChannels isEmpty.
	self assert: middlewareB outboundChannelsDict isEmpty.
	proxyB := middlewareB proxyTo: remoteReferenceA.
	self waitUntil: [middlewareA inboundChannels size = 1].
	self waitUntil: [middlewareB outboundChannelsDict size = 1].
	self assert: (middlewareA inboundChannels anyOne) isStarted.
	self assert: (middlewareB outboundChannelsDict at: remoteReferenceA) isStarted.
]

{ #category : #tests }
MpMiddlewareTestOLD >> testException [
	| remoteReference proxy |
	remoteReference := middlewareA export: Object new.
	proxy := middlewareB proxyTo: remoteReference.
	self should: [proxy foo] raise: MpRemoteException
]

{ #category : #tests }
MpMiddlewareTestOLD >> testInboundChannelReceiveObject [
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
MpMiddlewareTestOLD >> testMessagesInDifferentProcessesGetValidResponses [
	| valueHolderA1 valueHolderA2 remoteReferenceA1 remoteReferenceA2 proxyB1 proxyB2 semaphore1 semaphore2 result1 result2 process1 process2 |
	valueHolderA1 := self newValueHolder.
	valueHolderA1 contents: 1.
	remoteReferenceA1 := middlewareA export: valueHolderA1.
	valueHolderA2 := self newValueHolder.
	valueHolderA2 contents: 2.
	remoteReferenceA2 := middlewareA export: valueHolderA2.
	proxyB1 := middlewareB proxyTo: remoteReferenceA1.
	semaphore1 := Semaphore new.
	proxyB2 := middlewareB proxyTo: remoteReferenceA2.
	semaphore2 := Semaphore new.
	process1 := CcService do: [ 
		result1 := proxyB1 contents.
		semaphore1 signal.
	 ].
	process2 := CcService do: [ 
		result2 := proxyB2 contents.
		semaphore2 signal.
	 ].
	{process1. process2} do: [ : each |
		each
			priority: 20;
			start

	].
	self assertSemaphore: semaphore1 signaledWithinMilliseconds: 500.
	self assertSemaphore: semaphore2 signaledWithinMilliseconds: 500.
	self assert: result1 equals: 1.
	self assert: result2 equals: 2.
	
]

{ #category : #tests }
MpMiddlewareTestOLD >> testOutboundChannelSendMessageNoWait [
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
MpMiddlewareTestOLD >> testProxyCreatedOnDemand [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlewareTestOLD >> testProxyCreatedOnlyOnce [
	| remoteReference proxy1 proxy2 |
	remoteReference := middlewareA export: self newValueHolder.
	proxy1 := middlewareB proxyTo: remoteReference.
	proxy2 := middlewareB proxyTo: remoteReference.
	self assert: proxy1 == proxy2.
	
]

{ #category : #tests }
MpMiddlewareTestOLD >> testProxyOnBlock [
	| remoteReference proxy |
	remoteReference := middlewareA export: [1+2].
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy value equals: 3
]

{ #category : #tests }
MpMiddlewareTestOLD >> testProxyOnClass [
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
MpMiddlewareTestOLD >> testProxyUnicity [
	| remoteReferenceA proxyB remoteReferenceACopy |
	remoteReferenceA := middlewareA export: Object new.
	proxyB := middlewareB proxyTo: remoteReferenceA.
	self assert: (middlewareB proxyTo: remoteReferenceA) == proxyB.
	remoteReferenceACopy := remoteReferenceA deepCopy.
	self assert: (middlewareB proxyTo: remoteReferenceACopy) == proxyB.
	
]

{ #category : #tests }
MpMiddlewareTestOLD >> testProxyYourself [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy yourself == proxy
]

{ #category : #tests }
MpMiddlewareTestOLD >> testRemoteMessageSendFailure [
	| proxyB remoteReferenceA outboundChannelB |
	remoteReferenceA := middlewareA export: Object new.
	outboundChannelB := middlewareB transporter newChannel.
	proxyB := middlewareB proxyClass transporter: outboundChannelB remoteReference: remoteReferenceA.
	self should: [proxyB foo] raise: MpRemoteMessageSendError.

]

{ #category : #tests }
MpMiddlewareTestOLD >> testResultPassByCopy [
	| valueHolderA proxyB remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	proxyB := middlewareB proxyTo: remoteReferenceA.
	self passByCopyObjects do: [ : arg |
		valueHolderA contents: arg.
		self denyIsProxy: proxyB contents. 
		self assert: proxyB contents equals: arg]

]

{ #category : #tests }
MpMiddlewareTestOLD >> testResultPassByReference [
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
MpMiddlewareTestOLD >> testResultProxyToObjectInThirdMiddleware [
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
MpMiddlewareTestOLD >> testTimeoutRemoteMessage [
	| proxy remoteReference infiniteWaitSemaphore doneSemaphore isTimeout |
	infiniteWaitSemaphore := Semaphore new.
	doneSemaphore := Semaphore new.
	remoteReference := middlewareA export: infiniteWaitSemaphore.
	proxy := middlewareB proxyTo: remoteReference.
	isTimeout := false.
	[
		[proxy wait] on: MpRemoteMessageResultTimeout do: [: ex | isTimeout := true].
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinMilliseconds: 200.
	self assert: isTimeout.

]
