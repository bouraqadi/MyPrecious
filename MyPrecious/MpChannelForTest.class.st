Class {
	#name : #MpChannelForTest,
	#superclass : #MpChannel,
	#instVars : [
		'targetChannel'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpChannelForTest >> protocolClass [
	^MpProtocolForTest
]

{ #category : #communicating }
MpChannelForTest >> sendBytes: bytes [ 
	targetChannel receiveBytes: bytes
]

{ #category : #accessing }
MpChannelForTest >> targetChannel [
	^ targetChannel
]

{ #category : #accessing }
MpChannelForTest >> targetChannel: otherSide [
	targetChannel := otherSide.

]
