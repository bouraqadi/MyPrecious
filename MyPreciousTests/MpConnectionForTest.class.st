Class {
	#name : #MpConnectionForTest,
	#superclass : #MpConnection,
	#traits : 'CcTWaitPolling',
	#classTraits : 'CcTWaitPolling classTrait',
	#instVars : [
		'otherSide',
		'receiveQueue',
		'sendQueue'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #connecting }
MpConnectionForTest >> connect [
	| targetTransporter |
	targetTransporter := self registry at: self otherSideAddress.
	targetTransporter connectionQueue nextPut: self.
	self 
		waitUntil: [ self isConnected ] 
		onTimeout: self receptionTimeoutDuration
		do: [ MpConnectionFailed signal ]

]

{ #category : #connecting }
MpConnectionForTest >> connectTo: aConnection [
	self 
		otherSide: aConnection;
		sendQueue: SharedQueue new;
		receiveQueue: SharedQueue new.

	aConnection 
		otherSide: self;
		sendQueue: self receiveQueue;
		receiveQueue: self sendQueue.
]

{ #category : #connecting }
MpConnectionForTest >> disconnect [
	otherSide disconnect.
	sendQueue := nil.
	receiveQueue := nil

]

{ #category : #connecting }
MpConnectionForTest >> isSendingPossible [
	^sendQueue isNotNil
]

{ #category : #accessing }
MpConnectionForTest >> otherSide [
	^ otherSide
]

{ #category : #accessing }
MpConnectionForTest >> otherSide: anObject [
	otherSide := anObject
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
