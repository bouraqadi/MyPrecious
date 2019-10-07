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
MpConnection >> deliverReceivedObject [
	self receiveObject deliverBy: self
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

{ #category : #sending }
MpConnection >> marshalAndSerialize: anObject [
	^self transporter marshalAndSerialize: anObject
]

{ #category : #receiving }
MpConnection >> materializeAndUnmarshal: bytes [
	^self transporter materializeAndUnmarshal: bytes
]

{ #category : #receiving }
MpConnection >> newReceptionServiceDoing: aBlock [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnection >> receiveBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnection >> receiveObject [
	^self materializeAndUnmarshal: self receiveBytes.
	
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
	service := self newReceptionServiceDoing: [self deliverReceivedObject].
	service start
]

{ #category : #accessing }
MpConnection >> transporter [
	^ transporter
]

{ #category : #accessing }
MpConnection >> transporter: anObject [
	transporter := anObject
]
