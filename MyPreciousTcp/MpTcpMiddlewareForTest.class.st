Class {
	#name : #MpTcpMiddlewareForTest,
	#superclass : #MpTcpMiddleware,
	#traits : 'MpTMiddlewareDebugSupport',
	#classTraits : 'MpTMiddlewareDebugSupport classTrait',
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpMiddlewareForTest >> channelFactoryClass [ 
	^MpTcpChannelFactoryForTest 
]
