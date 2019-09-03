Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpMiddlewareForTest >> channelClass [
	^MpChannelForTest 
]

{ #category : #initialization }
MpMiddlewareForTest >> channelFactoryClass [
	^MpChannelFactoryForTest
]

{ #category : #initialization }
MpMiddlewareForTest >> referenceConverterClass [
	^MpReferenceConverterForTest
]

{ #category : #accessing }
MpMiddlewareForTest >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]

{ #category : #communicating }
MpMiddlewareForTest >> waitForResultTimeoutDuration [
	^100 milliSeconds
]
