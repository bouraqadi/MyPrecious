Class {
	#name : #MpConnection,
	#superclass : #Object,
	#traits : 'MpTPostMan',
	#classTraits : 'MpTPostMan classTrait',
	#instVars : [
		'transporter',
		'receptionService',
		'otherSideAddress'
	],
	#category : #'MyPrecious-Connected'
}

{ #category : #connecting }
MpConnection >> acceptConnectionWith: anObject [
	self subclassResponsibility
]

{ #category : #accessing }
MpConnection >> address [
	^self transporter address
]

{ #category : #connecting }
MpConnection >> basicConnect [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnection >> basicDisconnect [
	self subclassResponsibility
]

{ #category : #connecting }
MpConnection >> connect [
	| metaMessage |
	self basicConnect.
	metaMessage := MpSaveConnectionMetaMessage new.
	metaMessage otherSideAddress: self address.
	self sendObject: metaMessage
]

{ #category : #receiving }
MpConnection >> deliverResponse: aResponse [
	self transporter deliverResponse: aResponse
]

{ #category : #receiving }
MpConnection >> deliverSaveConnection: saveConnectionMetaMessage [
	self otherSideAddress: saveConnectionMetaMessage otherSideAddress.
	self transporter saveConnection: self toAddress: saveConnectionMetaMessage otherSideAddress
]

{ #category : #receiving }
MpConnection >> deliverSynchronousMessage: remoteMessage [
	| response |
	response := self basicDeliverSynchronousMessage: remoteMessage.
	[self sendObject: response] on: Exception do: [ : exception | self sendingResponseToMessage: remoteMessage raised: exception ]
]

{ #category : #connecting }
MpConnection >> disconnect [
	[self basicDisconnect] on: Exception do: [ "ignore" ]
]

{ #category : #connecting }
MpConnection >> isConnected [
	^self isReceptionStarted and: [ self isSendingPossible ]
]

{ #category : #connecting }
MpConnection >> isReceptionStarted [
	^receptionService notNil and: [receptionService isRunning]
]

{ #category : #connecting }
MpConnection >> isReceptionStopped [
	^receptionService isStopped
]

{ #category : #connecting }
MpConnection >> isSendingPossible [
	self subclassResponsibility
]

{ #category : #sending }
MpConnection >> marshalAndSerialize: anObject [
	^self transporter marshalAndSerialize: anObject
]

{ #category : #receiving }
MpConnection >> materializeAndUnmarshal: bytes [
	^self transporter materializeAndUnmarshal: bytes
]

{ #category : #accessing }
MpConnection >> otherSideAddress [
	^ otherSideAddress
]

{ #category : #accessing }
MpConnection >> otherSideAddress: anObject [
	otherSideAddress := anObject
]

{ #category : #receiving }
MpConnection >> receiveBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnection >> receiveObject [
	| receivedBytes receivedObject|
	receivedBytes := [self receiveBytes] on: Exception do: [ ^self ].
	self schedule: [
		receivedObject := self materializeAndUnmarshal: receivedBytes.
		receivedObject deliverBy: self
	]
]

{ #category : #accessing }
MpConnection >> receptionPriority [
	^ self transporter receptionPriority
]

{ #category : #receiving }
MpConnection >> receptionServiceName [
	^String streamContents: [: stream |
		stream 
			<< 'Connection from ';
			print: self address;
			<< ' to ';
			print: self otherSideAddress]
]

{ #category : #accessing }
MpConnection >> receptionTimeoutDuration [
	^ self transporter receptionTimeoutDuration
]

{ #category : #connecting }
MpConnection >> reset [
	self disconnect.
	self stopReceiving.
	self connect.
	self startReceiving
]

{ #category : #sending }
MpConnection >> sendBytes: bytes [
	self subclassResponsibility
]

{ #category : #sending }
MpConnection >> sendObject: anObject [
	| bytes |
	bytes := self marshalAndSerialize: anObject.
	self sendBytes: bytes
]

{ #category : #receiving }
MpConnection >> sendingResponseToMessage: remoteMessage raised: exception [
	| logString |
	logString := String streamContents: [: stream|
		stream
			cr;
			print: Time now;
			cr;
			print: self address;
			cr;
			<<  'Could not send response to message ';
			print: remoteMessage selector; 
			cr;
			<< exception description;
			cr
			].
	self log: logString
]

{ #category : #receiving }
MpConnection >> startReceiving [
	self isReceptionStarted
		ifTrue: [ ^ self ].
	receptionService := TKTParameterizableService new.
	receptionService
		step: [ self receiveObject ];
		stepDelay: 0 milliSecond;
		priority: self receptionPriority;
		name: self receptionServiceName;
		start
]

{ #category : #receiving }
MpConnection >> stopReceiving [
	receptionService stop
]

{ #category : #accessing }
MpConnection >> transporter [
	^ transporter
]

{ #category : #accessing }
MpConnection >> transporter: anObject [
	transporter := anObject
]
