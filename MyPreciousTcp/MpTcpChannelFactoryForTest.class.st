Class {
	#name : #MpTcpChannelFactoryForTest,
	#superclass : #MpTcpChannelFactory,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactoryForTest >> newInboundChannelWith: anObject [
	| newChannel |
	newChannel := (super newInboundChannelWith: anObject)
		sendQueue: SharedQueue new;
		receiveQueue: SharedQueue new;
		yourself.
	^newChannel
]
