Class {
	#name : #MpChannelFactoryForTest,
	#superclass : #MpChannelFactory,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelFactoryForTest >> channelTo: remoteReference [
	| otherMiddleware inboundChannel outboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware channelFactory newChannel.
	outboundChannel := self newChannel.
	outboundChannel targetChannel: inboundChannel.
	inboundChannel targetChannel: outboundChannel.
	^outboundChannel
]

{ #category : #communicating }
MpChannelFactoryForTest >> registry [
	^self middleware registry
]
