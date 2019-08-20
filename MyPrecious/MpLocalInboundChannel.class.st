Class {
	#name : #MpLocalInboundChannel,
	#superclass : #MpInboundChannel,
	#instVars : [
		'targetChannel'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #sending }
MpLocalInboundChannel >> sendBytes: bytes [ 
	targetChannel receiveBytes: bytes
]

{ #category : #accessing }
MpLocalInboundChannel >> targetChannel [
	^ targetChannel
]

{ #category : #accessing }
MpLocalInboundChannel >> targetChannel: anObject [
	targetChannel := anObject
]
