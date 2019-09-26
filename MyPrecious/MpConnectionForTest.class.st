Class {
	#name : #MpConnectionForTest,
	#superclass : #MpConnection,
	#traits : 'CcTWaitPolling',
	#classTraits : 'CcTWaitPolling classTrait',
	#instVars : [
		'communicationQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpConnectionForTest >> communicationQueue [
	^ communicationQueue
]

{ #category : #accessing }
MpConnectionForTest >> communicationQueue: anObject [
	communicationQueue := anObject
]

{ #category : #connecting }
MpConnectionForTest >> connectTo: targetRemoteReference [
	| targetTransporter |
	targetTransporter := self registry at: targetRemoteReference address.
	communicationQueue := SharedQueue new.
	targetTransporter connectionQueue nextPut: communicationQueue.

]

{ #category : #receiving }
MpConnectionForTest >> receiveBytes [
	self waitWhile: [communicationQueue peek isNil] timeout: 100 milliSeconds.
	^communicationQueue next
]

{ #category : #connecting }
MpConnectionForTest >> registry [
	^self transporter registry
]

{ #category : #sending }
MpConnectionForTest >> sendBytes: bytes [
	communicationQueue nextPut: bytes
]
