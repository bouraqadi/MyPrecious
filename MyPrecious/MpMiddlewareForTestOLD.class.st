Class {
	#name : #MpMiddlewareForTestOLD,
	#superclass : #MpMiddleware,
	#traits : 'MpTMiddlewareDebugSupportOLD',
	#classTraits : 'MpTMiddlewareDebugSupportOLD classTrait',
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpMiddlewareForTestOLD >> channelClass [
	^MpChannelForTestOLD
]

{ #category : #initialization }
MpMiddlewareForTestOLD >> channelFactoryClass [
	^MpChannelFactoryForTestOLD
]

{ #category : #initialization }
MpMiddlewareForTestOLD >> referenceConverterClass [
	^MpReferenceConverterForTest
]

{ #category : #accessing }
MpMiddlewareForTestOLD >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]