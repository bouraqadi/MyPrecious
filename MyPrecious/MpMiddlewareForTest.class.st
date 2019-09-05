Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#traits : 'MpTMiddlewareDebugSupport',
	#classTraits : 'MpTMiddlewareDebugSupport classTrait',
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
MpMiddlewareForTest >> inboundChannels [
	^self channelFactory inboundChannels
]

{ #category : #initialization }
MpMiddlewareForTest >> referenceConverterClass [
	^MpReferenceConverterForTest
]

{ #category : #accessing }
MpMiddlewareForTest >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]
