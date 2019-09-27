Class {
	#name : #MpTransporter,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'receptionService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpTransporter >> address [
	^self middleware address
]

{ #category : #initialization }
MpTransporter >> initialize [
	super initialize.
	receptionService := self newReceptionService.

]

{ #category : #activity }
MpTransporter >> isStarted [
	^receptionService isStarted
]

{ #category : #activity }
MpTransporter >> isStopped [
	^receptionService isStopped
]

{ #category : #sending }
MpTransporter >> marshal: anObject [ 
	^self marshaller marshal: anObject 


]

{ #category : #sending }
MpTransporter >> marshalAndSerialize: anObject [
	| marshalledObject |
	marshalledObject := self marshal: anObject.
	^ self serialize: marshalledObject
]

{ #category : #accessing }
MpTransporter >> marshaller [
	^self middleware marshaller
]

{ #category : #receiving }
MpTransporter >> materializeAndUnmarshal: bytes [
	| object |
	object := self materializeFrom: bytes.
	^self unmarshal: object
]

{ #category : #receiving }
MpTransporter >> materializeFrom: bytes [ 
	^FLMaterializer materializeFromByteArray: bytes
]

{ #category : #initialization }
MpTransporter >> newReceptionService [
	self subclassResponsibility
]

{ #category : #initialization }
MpTransporter >> receptionServicePriority: anInteger [
	receptionService priority: anInteger
]

{ #category : #sending }
MpTransporter >> receptionTimeoutDuration [
	^self middleware receptionTimeoutDuration
]

{ #category : #sending }
MpTransporter >> send: selector arguments: args to: targetRemoteReference [ 
	|remoteMessage responseId|
	responseId := self newId.
	remoteMessage := MpSynchronousRemoteMessage new
		selector: selector;
		arguments: args;
		receiver: targetRemoteReference;
		senderAddress: self address;
		responseId: responseId; 
		yourself.
	^self sendSynchronousMessage: remoteMessage to: targetRemoteReference
]

{ #category : #sending }
MpTransporter >> send: selector to: remoteReference [ 
	^self send: selector arguments: #() to: remoteReference
]

{ #category : #sending }
MpTransporter >> sendAsync: selector arguments: args to: targetRemoteReference [
	|remoteMessage|
	remoteMessage := MpAsynchronousRemoteMessage new
		selector: selector;
		arguments: args;
		receiver: targetRemoteReference;
		yourself.
	self sendAsynchronousMessage: remoteMessage to: targetRemoteReference
]

{ #category : #sending }
MpTransporter >> sendAsync: selector to: targetRemoteReference [ 
	self sendAsync: selector arguments: #() to: targetRemoteReference 
]

{ #category : #sending }
MpTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #sending }
MpTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #sending }
MpTransporter >> serialize: anObject [ 
	^FLSerializer serializeToByteArray: anObject
]

{ #category : #sending }
MpTransporter >> signalReceivingResponseOfRemoteMessage: remoteMessage raisedException: exception [
	MpRemoteMessageResultTimeout new
		message: remoteMessage;
		originalException: exception;
		signal
]

{ #category : #sending }
MpTransporter >> signalSendingRemoteMessage: remoteMessage raisedException: ex [
	^ MpCouldNotDeliverMessageError new
		message: remoteMessage;
		originalException: ex;
		signal
]

{ #category : #activity }
MpTransporter >> start [
	receptionService start
]

{ #category : #activity }
MpTransporter >> stop [
	receptionService stop
]

{ #category : #receiving }
MpTransporter >> unmarshal: anObject [ 
	^self marshaller unmarshal: anObject.
]
