Class {
	#name : #MpMiddlewareTest,
	#superclass : #TestCase,
	#traits : 'CcTConcurrencyTest + CcTWaitPolling',
	#classTraits : 'CcTConcurrencyTest classTrait + CcTWaitPolling classTrait',
	#instVars : [
		'middlewareA',
		'middlewareB',
		'middlewareC'
	],
	#category : #'MyPrecious-Tests'
}

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
MpMiddlewareTest >> defaultWaitForResultTimeoutDuration [
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
	^ MpMiddlewareForTest
]

{ #category : #tests }
MpMiddlewareTest >> newMiddleware [
	^self middlewareClass new
		waitForResultTimeoutDuration: self defaultWaitForResultTimeoutDuration;
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
	self allMiddleware do: [ : each | each stop]
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
	remoteReference :=  middlewareA export: self newValueHolder id: id.
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
MpMiddlewareTest >> testProxyUnicity [
	| remoteReferenceA proxyB remoteReferenceACopy |
	remoteReferenceA := middlewareA export: Object new.
	proxyB := middlewareB proxyTo: remoteReferenceA.
	self assert: (middlewareB proxyTo: remoteReferenceA) == proxyB.
	remoteReferenceACopy := remoteReferenceA deepCopy.
	self assert: (middlewareB proxyTo: remoteReferenceACopy) == proxyB.
	
]

{ #category : #tests }
MpMiddlewareTest >> testProxyYourself [
	| remoteReference proxy |
	remoteReference := middlewareA export: self newValueHolder.
	proxy := middlewareB proxyTo: remoteReference.
	self assert: proxy yourself == proxy
]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageSendToNilAddress [
	| proxyA |
	proxyA := middlewareA proxyClass 
		transporter: middlewareA transporter 
		remoteReference: MpRemoteReference new.
	self should: [proxyA foo] raise: MpRemoteMessageSendError.

]

{ #category : #tests }
MpMiddlewareTest >> testRemoteMessageSendToNilReference [
	| proxyA |
	proxyA := middlewareA proxyClass 
		transporter: middlewareA transporter 
		remoteReference: nil.
	self should: [proxyA foo] raise: MpRemoteMessageSendError.

]

{ #category : #tests }
MpMiddlewareTest >> testResultPassByCopy [
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
		[proxy wait] on: MpRemoteMessageResultTimeout do: [: ex | isTimeout := true].
		doneSemaphore signal.
	 ] fork.
	self assertSemaphore: doneSemaphore signaledWithinMilliseconds: 200.
	self assert: isTimeout.

]
