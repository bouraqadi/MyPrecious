Class {
	#name : #MpTcpChannel,
	#superclass : #MpChannel,
	#instVars : [
		'socketStream'
	],
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannel >> communicateVia: aSocketStream [
	socketStream := aSocketStream.
	[socketStream isConnected] whileTrue: [ self receiveObject ]
]

{ #category : #communicating }
MpTcpChannel >> receiveObject [
	self protocol receiveBytes
]

{ #category : #accessing }
MpTcpChannel >> socketStream [
	^socketStream
]
