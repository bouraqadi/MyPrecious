Class {
	#name : #MpTcpMiddleware,
	#superclass : #MpMiddleware,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpMiddleware >> channelFactoryClass [
	^MpTcpChannelFactory
]
