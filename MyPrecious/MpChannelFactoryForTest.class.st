Class {
	#name : #MpChannelFactoryForTest,
	#superclass : #MpChannelFactory,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelFactoryForTest >> outboundChannelTo: remoteReference [
	| otherMiddleware inboundChannel outboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware channelFactory newInboundChannel.
	outboundChannel := self newOutboundChannel.
	outboundChannel targetChannel: inboundChannel.
	inboundChannel targetChannel: outboundChannel.
	^outboundChannel
]

{ #category : #communicating }
MpChannelFactoryForTest >> registry [
	^self middleware registry
]
