Class {
	#name : #MpConnection,
	#superclass : #Object,
	#traits : 'MpTPostMan',
	#classTraits : 'MpTPostMan classTrait',
	#instVars : [
		'transporter',
		'service'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpConnection >> connectTo: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnection >> deliverResponse: aResponse [
	self transporter deliverResponse: aResponse
]

{ #category : #receiving }
MpConnection >> deliverSaveConnection: saveConnectionMetaMessage [
	self transporter saveConnection: self to: saveConnectionMetaMessage otherSideAddress
]

{ #category : #receiving }
MpConnection >> deliverSynchronousMessage: remoteMessage [
	| response |
	response := self basicDeliverSynchronousMessage: remoteMessage.
	self sendObject: response
]

{ #category : #testing }
MpConnection >> isClosed [
	^service isStopped
]

{ #category : #connecting }
MpConnection >> isConnected [
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
MpConnection >> processingPriority [
	^ self transporter processingPriority
]

{ #category : #receiving }
MpConnection >> receiveBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnection >> receiveObject [
	| receivedBytes receivedObject|
	receivedBytes := [self receiveBytes] on: Exception do: [ ^self ].
	[
		receivedObject := self materializeAndUnmarshal: receivedBytes.
		receivedObject deliverBy: self
	] forkAt: self processingPriority
]

{ #category : #accessing }
MpConnection >> receptionPriority [
	^ self transporter receptionPriority
]

{ #category : #accessing }
MpConnection >> receptionTimeoutDuration [
	^ self transporter receptionTimeoutDuration
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
MpConnection >> startReceiving [
	service := CcService repeat: [self receiveObject].
	service priority: self receptionPriority.
	service start
]

{ #category : #receiving }
MpConnection >> stopReceiving [
	service stop
]

{ #category : #accessing }
MpConnection >> transporter [
	^ transporter
]

{ #category : #accessing }
MpConnection >> transporter: anObject [
	transporter := anObject
]