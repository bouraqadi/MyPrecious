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
MpMiddlewareTest >> testProxyCreatedWithGivenId [
	| remoteReference proxy id |
	id := #someUniqueID.
	remoteReference :=  middlewareA export: self newValueHolder id: id.
	proxy := middlewareB proxyTo: remoteReference.
	self assertIsProxy: proxy
]
