Class {
	#name : #MpOutboundChannelForTest,
	#superclass : #MpOutboundChannel,
	#instVars : [
		'targetChannel'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpOutboundChannelForTest >> sendBytes: bytes [ 
	targetChannel receiveBytes: bytes
]

{ #category : #accessing }
MpOutboundChannelForTest >> targetChannel [
	^ targetChannel
]

{ #category : #accessing }
MpOutboundChannelForTest >> targetChannel: inboundChannel [
	targetChannel := inboundChannel.
	inboundChannel targetChannel: self
]
