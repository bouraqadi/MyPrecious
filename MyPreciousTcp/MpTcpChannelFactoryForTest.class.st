Class {
	#name : #MpTcpChannelFactoryForTest,
	#superclass : #MpTcpChannelFactory,
	#instVars : [
		'inboundChannels'
	],
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
