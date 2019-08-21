Class {
	#name : #MpInboundChannelForTest,
	#superclass : #MpInboundChannel,
	#instVars : [
		'targetChannel'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #sending }
MpInboundChannelForTest >> sendBytes: bytes [ 
	targetChannel receiveBytes: bytes
]

{ #category : #accessing }
MpInboundChannelForTest >> targetChannel [
	^ targetChannel
]

{ #category : #accessing }
MpInboundChannelForTest >> targetChannel: anObject [
	targetChannel := anObject
]
