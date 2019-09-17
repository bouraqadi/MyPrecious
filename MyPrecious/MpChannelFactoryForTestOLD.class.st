Class {
	#name : #MpChannelFactoryForTestOLD,
	#superclass : #MpChannelFactoryOLD,
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelFactoryForTestOLD >> newInboundChannelWith: anObject [
	^(super newInboundChannelWith: anObject)
		sendQueue: SharedQueue new;
		receiveQueue: SharedQueue new;
		yourself
]

{ #category : #communicating }
MpChannelFactoryForTestOLD >> newOutboundChannelTo: remoteReference [
	| otherMiddleware inboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware transporter inboundChannelWith: nil.
	^(super newOutboundChannelTo: remoteReference)
		sendQueue: inboundChannel receiveQueue;
		receiveQueue: inboundChannel sendQueue;
		yourself
]
