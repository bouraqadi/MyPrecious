Class {
	#name : #MpTcpMiddlewareForTest,
	#superclass : #MpTcpMiddleware,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpMiddlewareForTest >> channelFactoryClass [ 
	^MpTcpChannelFactoryForTest 
]

{ #category : #initialization }
MpTcpMiddlewareForTest >> inboundChannels [
	^self channelFactory inboundChannels
]
