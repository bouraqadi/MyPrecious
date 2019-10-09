Class {
	#name : #MpConnectionForTest,
	#superclass : #MpConnection,
	#traits : 'CcTWaitPolling',
	#classTraits : 'CcTWaitPolling classTrait',
	#instVars : [
		'receiveQueue',
		'sendQueue'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #connecting }
MpConnectionForTest >> connect [
	| targetTransporter |
	targetTransporter := self registry at: self otherSideAddress.
	sendQueue := SharedQueue new.
	receiveQueue := SharedQueue new.
	targetTransporter connectionQueue nextPut: {sendQueue. receiveQueue}.

]

{ #category : #connecting }
MpConnectionForTest >> isSendingPossible [
	^sendQueue isNotNil
]

{ #category : #receiving }
MpConnectionForTest >> receiveBytes [
	self waitWhile: [receiveQueue peek isNil] timeout: self receptionTimeoutDuration.
	^receiveQueue next
]

{ #category : #accessing }
MpConnectionForTest >> receiveQueue [
	^ receiveQueue
]

{ #category : #accessing }
MpConnectionForTest >> receiveQueue: anObject [
	receiveQueue := anObject
]

{ #category : #connecting }
MpConnectionForTest >> registry [
	^self transporter registry
]

{ #category : #sending }
MpConnectionForTest >> sendBytes: bytes [
	sendQueue nextPut: bytes
]

{ #category : #accessing }
MpConnectionForTest >> sendQueue [
	^ sendQueue
]

{ #category : #accessing }
MpConnectionForTest >> sendQueue: anObject [
	sendQueue := anObject
]
