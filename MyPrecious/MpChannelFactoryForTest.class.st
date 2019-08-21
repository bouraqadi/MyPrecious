Class {
	#name : #MpChannelFactoryForTest,
	#superclass : #MpChannelFactory,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelFactoryForTest >> inboundChannelClass [
	^ MpInboundChannelForTest
]

{ #category : #communicating }
MpChannelFactoryForTest >> newOutboundChannelTo: remoteReference [
	| otherMiddleware inboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware channelFactory inboundChannel.
	^(super newOutboundChannelTo: remoteReference)
		targetChannel: inboundChannel;
		yourself.
	
]

{ #category : #communicating }
MpChannelFactoryForTest >> outboundChannelClass [
	^MpOutboundChannelForTest 
]

{ #category : #communicating }
MpChannelFactoryForTest >> registry [
	^self middleware registry
]
