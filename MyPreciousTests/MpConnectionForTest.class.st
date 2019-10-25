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
MpConnectionForTest >> acceptConnectionFrom: aConnection [
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
MpConnectionForTest >> acceptConnectionWith: aConnection [
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
MpConnectionForTest >> basicConnect [
	| targetTransporter |
	targetTransporter := self registry at: self otherSideAddress ifAbsent: [MpConnectionFailed signal].
	targetTransporter connectionQueue nextPut: self.
	self 
		waitUntil: [ self isSendingPossible ] 
		onTimeout: self receptionTimeoutDuration
		do: [ MpConnectionFailed signal ]

]

{ #category : #connecting }
MpConnectionForTest >> basicDisconnect [
	| peer |
	otherSide ifNil: [^self].
	sendQueue := nil.
	peer := otherSide.
	otherSide := nil.
	peer disconnect.


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

{ #category : #receiving }
MpConnectionForTest >> receptionServiceName [
	^String streamContents: [ : stream |
		stream 
			<< 'Connection from ';
			print: Time now ]
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
