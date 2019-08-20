Class {
	#name : #MpLocalOutboundChannel,
	#superclass : #MpOutboundChannel,
	#instVars : [
		'targetChannel'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpLocalOutboundChannel >> sendBytes: bytes [ 
	targetChannel receiveBytes: bytes
]

{ #category : #accessing }
MpLocalOutboundChannel >> targetChannel [
	^ targetChannel
]

{ #category : #accessing }
MpLocalOutboundChannel >> targetChannel: inboundChannel [
	targetChannel := inboundChannel.
	inboundChannel targetChannel: self
]
