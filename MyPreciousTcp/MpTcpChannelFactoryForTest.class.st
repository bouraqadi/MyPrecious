Class {
	#name : #MpTcpChannelFactoryForTest,
	#superclass : #MpTcpChannelFactory,
	#instVars : [
		'inboundChannels'
	],
	#category : #MyPreciousTcp
}

{ #category : #accessing }
MpTcpChannelFactoryForTest >> inboundChannels [
	^inboundChannels
]

{ #category : #initialization }
MpTcpChannelFactoryForTest >> initialize [
	super initialize.
	inboundChannels := Set new.
]

{ #category : #initialization }
MpTcpChannelFactoryForTest >> newInboundChannel [
	| newChannel |
	newChannel := super newInboundChannel.
	inboundChannels add: newChannel.
	^newChannel
]
