Class {
	#name : #MpChannelForTest,
	#superclass : #MpChannel,
	#instVars : [
		'sendQueue',
		'receiveQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #communicating }
MpChannelForTest >> receiveBytes [
	^receiveQueue next
]

{ #category : #accessing }
MpChannelForTest >> receiveQueue [
	^ receiveQueue
]

{ #category : #accessing }
MpChannelForTest >> receiveQueue: anObject [
	receiveQueue := anObject
]

{ #category : #communicating }
MpChannelForTest >> sendBytes: bytes [
	sendQueue nextPut: bytes
]

{ #category : #accessing }
MpChannelForTest >> sendQueue [
	^ sendQueue
]

{ #category : #accessing }
MpChannelForTest >> sendQueue: anObject [
	sendQueue := anObject
]
