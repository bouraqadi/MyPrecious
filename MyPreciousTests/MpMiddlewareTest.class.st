Class {
	#name : #MpMiddlewareTest,
	#superclass : #TestCase,
	#traits : 'CcTConcurrencyTest',
	#classTraits : 'CcTConcurrencyTest classTrait',
	#instVars : [
		'middlewareA',
		'middlewareB',
		'middlewareC'
	],
	#category : #'MyPreciousTests-Common'
}

{ #category : #testing }
MpMiddlewareTest class >> isAbstract [
	^self == MpMiddlewareTest
]

{ #category : #testing }
MpMiddlewareTest class >> shouldInheritSelectors [
	^true
]

{ #category : #tests }
MpMiddlewareTest >> allMiddleware [
	^{ middlewareA . middlewareB . middlewareC }
]

{ #category : #tests }
MpMiddlewareTest >> assert: anObject instanceOf: aClass [
	self assert: (self is: anObject instanceOf: aClass)
]

{ #category : #tests }
MpMiddlewareTest >> assertIsProxy: anObject [
		self assert: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlewareTest >> defaultReceptionTimeoutDuration [
	^100 milliSeconds
]

{ #category : #tests }
MpMiddlewareTest >> denyIsProxy: anObject [
		self deny: (self isProxy: anObject). 

]

{ #category : #tests }
MpMiddlewareTest >> is: anObject instanceOf: aClass [
	"We cannot rely on the class messare or messages that use it such as isKindOf:"
	"This is proxies are supposed to capture all message including class"
	| actualClass |
	actualClass := (ProtoObject compiledMethodAt: #class) valueWithReceiver: anObject arguments: #().
	^actualClass includesBehavior: aClass

]

{ #category : #tests }
MpMiddlewareTest >> isProxy: anObject [
	^self is: anObject instanceOf: MpProxy
]

{ #category : #tests }
MpMiddlewareTest >> middlewareClass [
	self subclassResponsibility
]

{ #category : #tests }
MpMiddlewareTest >> newMiddleware [
	^self middlewareClass new
		receptionTimeoutDuration: self defaultReceptionTimeoutDuration;
		yourself

]

{ #category : #tests }
MpMiddlewareTest >> newValueHolder [
	^ MpValueHolderForTest new
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
	"Currently SUnit terminates all forked threads upon failure.
This makes debugging very hard, if not impossible! We need to guess the state of the threads, since they are all terminated.
Simply calling runCase is a dirty fix.
We have to take care of terminating threads upon failures.
"
	thisContext sender methodSelector == #runCaseForDebug: ifTrue: [^self runCase].
	^super runCaseManaged
]

{ #category : #tests }
MpMiddlewareTest >> setUp [
	super setUp.
	middlewareA := self newMiddleware.
	middlewareB := self newMiddleware.
	middlewareC := self newMiddleware.
	self allMiddleware do: #start.
	
]

{ #category : #tests }
MpMiddlewareTest >> tearDown [
	super tearDown.
	self allMiddleware do: #stop.
	MpMiddlewareForTest resetRegistry.

]

{ #category : #tests }
MpMiddlewareTest >> testArgPassByCopy [
	| valueHolderA remoteReferenceA proxyB |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	proxyB := middlewareB objectAt: remoteReferenceA.
	self passByCopyObjects do: [ : arg |
		proxyB contents: arg.
		self denyIsProxy: valueHolderA contents. 
		self assert: valueHolderA contents equals: arg]
	

]

{ #category : #tests }
MpMiddlewareTest >> testArgPassByReference [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB objectAt: remoteReference.
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
	proxyAInB := middlewareB objectAt: refA.
	c := self newValueHolder.
	refC := middlewareC export: c.
	proxyCInB := middlewareB objectAt: refC.
	proxyAInB contents: proxyCInB.
	proxyCInA := a contents.
	self assertIsProxy: proxyCInA.
	self deny: proxyCInA == proxyCInB.
	self passByCopyObjects do: [ : arg |
		proxyCInA contents: arg.
		self assert: c contents equals: arg]
	
]

{ #category : #tests }
MpMiddlewareTest >> testExportObject [
	| exportedObject remoteReferenceA exportedObjectCopy |
	exportedObject := self newValueHolder.
	remoteReferenceA := middlewareA export: exportedObject.
	self assert: (middlewareA export: exportedObject) equals: remoteReferenceA.
	exportedObjectCopy := self newValueHolder.
	self assert: exportedObjectCopy equals: exportedObject.
	self deny: exportedObjectCopy == exportedObject.
	self deny: (middlewareA export: exportedObjectCopy) equals: remoteReferenceA.
	
]

{ #category : #tests }
MpMiddlewareTest >> testExportedArrayReference [
	| exportedArray remoteReferenceA remoteReferenceACopy |
	exportedArray := Array new.
	remoteReferenceA := middlewareA export: exportedArray.
	self assert: (middlewareA objectAt: remoteReferenceA) == exportedArray.
	remoteReferenceACopy := remoteReferenceA deepCopy. 
	self assert: (middlewareA objectAt: remoteReferenceACopy) == exportedArray.
	self assert: (middlewareA remoteReferenceFor: exportedArray) equals: remoteReferenceA.	
	self deny: (middlewareA remoteReferenceFor: Array new) equals: remoteReferenceA.	
]

{ #category : #tests }
MpMiddlewareTest >> testExportedObjectReference [
	| exportedObject remoteReferenceA remoteReferenceACopy |
	exportedObject := Object new.
	remoteReferenceA := middlewareA export: exportedObject.
	self assert: (middlewareA objectAt: remoteReferenceA) == exportedObject.
	remoteReferenceACopy := remoteReferenceA deepCopy.
	self assert: (middlewareA objectAt: remoteReferenceACopy) == exportedObject.
	
]

{ #category : #tests }
MpMiddlewareTest >> testMessagePingPong [
	| valueHolderA1 remoteReferenceA1 proxyA1InB valueHolderB1 valueHolderA2 remoteReferenceB1 proxyB1InA remoteReferenceA2 proxyA2InB |
	valueHolderA1 := self newValueHolder.
	remoteReferenceA1 := middlewareA export: valueHolderA1.
	proxyA1InB := middlewareB objectAt: remoteReferenceA1.
	self assert: proxyA1InB chainSize equals: 1.
	valueHolderB1 := self newValueHolder.	
	valueHolderB1 contents: proxyA1InB.
	remoteReferenceB1 := middlewareB export: valueHolderB1.
	proxyB1InA := middlewareA objectAt: remoteReferenceB1.	
	self assert: proxyB1InA chainSize equals: 2.
	valueHolderA2 := self newValueHolder.
	valueHolderA2 contents: proxyB1InA.
	remoteReferenceA2 := middlewareA export: valueHolderA2.
	proxyA2InB := middlewareB objectAt: remoteReferenceA2.
	self assert: proxyA2InB chainSize equals: 3.

]

{ #category : #tests }
MpMiddlewareTest >> testMessagesInDifferentProcessesGetValidResponses [
	| valueHolderA1 valueHolderA2 remoteReferenceA1 remoteReferenceA2 proxyB1 proxyB2 semaphore1 semaphore2 result1 result2 block1 block2 |
	valueHolderA1 := self newValueHolder.
	valueHolderA1 contents: 1.
	remoteReferenceA1 := middlewareA export: valueHolderA1.
	valueHolderA2 := self newValueHolder.
	valueHolderA2 contents: 2.
	remoteReferenceA2 := middlewareA export: valueHolderA2.
	proxyB1 := middlewareB objectAt: remoteReferenceA1.
	semaphore1 := Semaphore new.
	proxyB2 := middlewareB objectAt: remoteReferenceA2.
	semaphore2 := Semaphore new.
	block1 := [ 
		result1 := proxyB1 contents.
		semaphore1 signal.
	 ].
	block2 := [ 
		result2 := proxyB2 contents.
		semaphore2 signal.
	 ].
	{block1. block2} do: [ : each |
		|task|
		task := TKTTask valuable: each.
		task schedule: TKTNewProcessTaskRunner new
	].
	self assertSemaphore: semaphore1 signaledWithinMilliseconds: 500.
	self assertSemaphore: semaphore2 signaledWithinMilliseconds: 500.
	self assert: result1 equals: 1.
	self assert: result2 equals: 2.
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedOnDemand [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB objectAt: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedOnlyOnce [
	| remoteReference proxy1 proxy2 |
	remoteReference := middlewareA export: self newValueHolder.
	proxy1 := middlewareB objectAt: remoteReference.
	proxy2 := middlewareB objectAt: remoteReference.
	self assert: proxy1 == proxy2.
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyCreatedWithGivenId [
	| remoteReference proxy id |
	id := #someUniqueID.
	remoteReference :=  middlewareA export: self newValueHolder id: id.
	proxy := middlewareB objectAt: remoteReference.
	self assertIsProxy: proxy
]

{ #category : #tests }
MpMiddlewareTest >> testProxyOnBlock [
	| remoteReference proxy |
	remoteReference := middlewareA export: [1+2].
	proxy := middlewareB objectAt: remoteReference.
	self assert: proxy value equals: 3
]

{ #category : #tests }
MpMiddlewareTest >> testProxyOnClass [
	| remoteReference classProxy instanceProxy otherRemoteRef otherClassProxy |
	remoteReference := middlewareA export: Object.
	classProxy := middlewareB objectAt: remoteReference.
	self assertIsProxy: classProxy.
	instanceProxy := classProxy new.
	self assertIsProxy: instanceProxy.
	self assert: (instanceProxy isKindOf: classProxy).
	otherRemoteRef := middlewareA export: Array.
	otherClassProxy := middlewareB objectAt: otherRemoteRef.
	self deny: classProxy == otherClassProxy
]

{ #category : #tests }
MpMiddlewareTest >> testProxyUnicity [
	| remoteReferenceA proxyB remoteReferenceACopy |
	remoteReferenceA := middlewareA export: Object new.
	proxyB := middlewareB objectAt: remoteReferenceA.
	self assert: (middlewareB objectAt: remoteReferenceA) == proxyB.
	remoteReferenceACopy := remoteReferenceA deepCopy.
	self assert: (middlewareB objectAt: remoteReferenceACopy) == proxyB.
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyYourself [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB objectAt: remoteReference.
	self assert: proxy yourself == proxy
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageAsynchronousSend0Args [
	| remoteReferenceA x blockA |
	x := 0.
	blockA := [ x := x + 1 ].
	remoteReferenceA := middlewareA export: blockA.
	middlewareB sendAsync: #value to: remoteReferenceA.
	self waitUntil: [x = 1] onTimeout: 300 milliSeconds do: [ self fail: 'Message not received' ].
	
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageAsynchronousSendToNilAddress [
	self should: [
		middlewareB sendAsync: #contents: arguments: #(3) to: MpRemoteReference new
	] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.
	self should: [
		middlewareB sendAsync: #size to: MpRemoteReference new
	] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.

]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageAsynchronousSendToNilReference [
	self should: [
		middlewareB sendAsync: #contents: arguments: #(3) to: nil
	] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.
	self should: [
		middlewareB sendAsync: #size to: nil
	] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.

]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageAsynchronousSendWithArgs [
	| valueHolderA remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	middlewareB sendAsync: #contents: arguments: #(3) to: remoteReferenceA.
	self waitUntil: [valueHolderA contents = 3] onTimeout: 300 milliSeconds do: [ self fail: 'Message not received' ].
	
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageRaisesException [
	| remoteReference proxy |
	remoteReference := middlewareA export: Object new.
	proxy := middlewareB objectAt: remoteReference.
	self should: [proxy foo] raise: MpRemoteExceptionWrapper
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageSynchronousSend [
	| arrayA remoteReferenceA|
	arrayA := #(100 200 300).
	remoteReferenceA := middlewareA export: arrayA.
	self assert: (middlewareB send: #size to: remoteReferenceA) equals: 3.
	self assert: (middlewareB send: #at: arguments: #(2) to: remoteReferenceA) equals: 200.
	
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageSynchronousSendToNilAddress [
	self should: [middlewareB send: #foo to: MpRemoteReference new] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.
	self should: [middlewareB send: #at: arguments: #(1) to: MpRemoteReference new] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.

]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageSynchronousSendToNilReference [
	self should: [middlewareB send: #foo to: nil] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.
	self should: [middlewareB send: #at: arguments: #(1) to: nil] raise: MpCouldNotDeliverMessageError, MpConnectionFailed.

]

{ #category : #tests }
MpMiddlewareTest >> testResultPassByCopy [
	| valueHolderA proxyB remoteReferenceA |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	proxyB := middlewareB objectAt: remoteReferenceA.
	self passByCopyObjects do: [ : arg |
		valueHolderA contents: arg.
		self denyIsProxy: proxyB contents. 
		self assert: proxyB contents equals: arg]

]

{ #category : #tests }
MpMiddlewareTest >> testResultPassByReference [
	| valueHolder proxy remoteReference |
	valueHolder := self newValueHolder.
	remoteReference := middlewareA export: valueHolder.
	proxy := middlewareB objectAt: remoteReference.
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
	proxyAInB := middlewareB objectAt: refA.
	c := self newValueHolder.
	refC := middlewareC export: c.
	proxyCInA := middlewareA objectAt: refC.
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
	| proxy remoteReference waitSemaphore doneSemaphore isTimeout |
	waitSemaphore := Semaphore new.
	doneSemaphore := Semaphore new.
	remoteReference := middlewareA export: waitSemaphore.
	proxy := middlewareB objectAt: remoteReference.
	isTimeout := false.
	[
		[proxy wait: 20 seconds] on: MpRemoteMessageResultTimeout do: [: ex | isTimeout := true].
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinSeconds: 3.
	self assert: isTimeout.

]

{ #category : #tests }
MpMiddlewareTest >> testUnknownReference [
	| remoteReference |
	remoteReference := middlewareA referenceConverter newRemoteReferenceWithId: #any.
	self should: [middlewareA objectAt: remoteReference ] raise: MpUnknownObject.
	{middlewareB. middlewareC} do: [: each | 
		self assertIsProxy: (each objectAt: remoteReference)
		 ]

]
