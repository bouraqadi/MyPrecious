Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

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
