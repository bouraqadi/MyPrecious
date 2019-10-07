Class {
	#name : #MpUnconnectedTransporter,
	#superclass : #MpTransporter,
	#traits : 'MpTPostMan',
	#classTraits : 'MpTPostMan classTrait',
	#instVars : [
		'receptionService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpUnconnectedTransporter >> deliverSynchronousMessage: remoteMessage [
	| response |
	response := self basicDeliverSynchronousMessage: remoteMessage.
	self sendObject: response toAddress: remoteMessage senderAddress
]

{ #category : #initialization }
MpUnconnectedTransporter >> initialize [
	super initialize.
	receptionService := self newReceptionService.

]

{ #category : #activity }
MpUnconnectedTransporter >> isStarted [
	^self receptionService isStarted
]

{ #category : #initialization }
MpUnconnectedTransporter >> newReceptionService [
	^CcService repeat: [ self receiveBytes ]
]

{ #category : #receiving }
MpUnconnectedTransporter >> readBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpUnconnectedTransporter >> receiveBytes [
	| bytes |
	bytes := self readBytes.
	[self receiveBytes: bytes] fork
]

{ #category : #receiving }
MpUnconnectedTransporter >> receiveBytes: bytes [
	| unmarshalledObject  |
	unmarshalledObject := self materializeAndUnmarshal: bytes.
	self receiveObject: unmarshalledObject
]

{ #category : #receiving }
MpUnconnectedTransporter >> receiveObject: anObject [
	anObject deliverBy: self
]

{ #category : #accessing }
MpUnconnectedTransporter >> receptionService [
	^ receptionService
]

{ #category : #initialization }
MpUnconnectedTransporter >> receptionServicePriority: anInteger [
	self receptionService priority: anInteger
]

{ #category : #sending }
MpUnconnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	[ self
		sendObject: remoteMessage
		toAddress: targetRemoteReference address 
	] 
		on: Error
		do: [ :ex | self signalSendingRemoteMessage: remoteMessage raisedException: ex ]
]

{ #category : #sending }
MpUnconnectedTransporter >> sendBytes: bytes toAddress: address [
	self subclassResponsibility

]

{ #category : #sending }
MpUnconnectedTransporter >> sendObject: anObject toAddress: address [
	| bytes |
	bytes := self marshalAndSerialize: anObject.
	self sendBytes: bytes toAddress: address
]

{ #category : #activity }
MpUnconnectedTransporter >> start [
	self receptionService start
]

{ #category : #activity }
MpUnconnectedTransporter >> stop [
	self receptionService stop
]
