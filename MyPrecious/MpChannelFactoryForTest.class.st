Class {
	#name : #MpChannelFactoryForTest,
	#superclass : #MpChannelFactory,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelFactoryForTest >> newInboundChannelWith: anObject [
	^(super newInboundChannelWith: anObject)
		sendQueue: SharedQueue new;
		receiveQueue: SharedQueue new;
		yourself
]

{ #category : #communicating }
MpChannelFactoryForTest >> newOutboundChannelTo: remoteReference [
	| otherMiddleware inboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware channelFactory inboundChannelWith: nil.
	^(super newOutboundChannelTo: remoteReference)
		sendQueue: inboundChannel receiveQueue;
		receiveQueue: inboundChannel sendQueue;
		yourself
]

{ #category : #communicating }
MpChannelFactoryForTest >> registry [
	^self middleware registry
]
