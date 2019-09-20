Class {
	#name : #MpTransporter,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'promisesDict',
		'promisesLock',
		'receptionService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpTransporter >> address [
	^self middleware address
]

{ #category : #receiving }
MpTransporter >> deliverAsynchronousMessage: remoteMessage [
	remoteMessage send 

]

{ #category : #receiving }
MpTransporter >> deliverResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #receiving }
MpTransporter >> deliverSynchronousMessage: remoteMessage [
	| response |
	response := [ 
		self normalResponseClass
			id: remoteMessage responseId
			result: remoteMessage send 
	] on: Exception do: [ :exception | 
		self exceptionResponseClass
				id: remoteMessage responseId
				exception: exception 
	].
	self sendObject: response toAddress: remoteMessage senderAddress
]

{ #category : #receiving }
MpTransporter >> exceptionResponseClass [
	^ MpExceptionRemoteResponse
]

{ #category : #initialization }
MpTransporter >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.
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

{ #category : #accessing }
MpTransporter >> marshaller [
	^self middleware marshaller
]

{ #category : #receiving }
MpTransporter >> materializeFrom: bytes [ 
	^FLMaterializer materializeFromByteArray: bytes
]

{ #category : #initialization }
MpTransporter >> newReceptionService [
	self subclassResponsibility
]

{ #category : #receiving }
MpTransporter >> normalResponseClass [
	^ MpNormalRemoteResponse
]

{ #category : #sending }
MpTransporter >> promiseClass [
	^ CcPromise
]

{ #category : #accessing }
MpTransporter >> promisesDict [
	^ promisesDict
]

{ #category : #receiving }
MpTransporter >> receiveBytes: bytes [
	| receivedObject  |
	receivedObject := self materializeFrom: bytes.
	self receiveObject: receivedObject
]

{ #category : #receiving }
MpTransporter >> receiveObject: anObject [
	| unmarshalledObject |
	unmarshalledObject := self unmarshal: anObject.
	unmarshalledObject deliverByTransporter: self
]

{ #category : #initialization }
MpTransporter >> receptionServicePriority: anInteger [
	receptionService priority: anInteger
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
	self sendMessage: remoteMessage to: targetRemoteReference
]

{ #category : #sending }
MpTransporter >> sendAsync: selector to: targetRemoteReference [ 
	self sendAsync: selector arguments: #() to: targetRemoteReference 
]

{ #category : #sending }
MpTransporter >> sendBytes: bytes toAddress: address [
	self subclassResponsibility

]

{ #category : #sending }
MpTransporter >> sendMessage: remoteMessage to: targetReference [
	[
		self sendObject: remoteMessage toAddress: targetReference address
	] on: Error do: [ : ex | 
		MpCouldNotDeliverMessageError new
			message: remoteMessage;
			originalException: ex;
			signal
	]
]

{ #category : #sending }
MpTransporter >> sendObject: anObject toAddress: address [
	| marshalledObject bytes |
	marshalledObject := self marshal: anObject.
	bytes := self serialize: marshalledObject.
	self sendBytes: bytes toAddress: address
]

{ #category : #sending }
MpTransporter >> sendSynchronousMessage: remoteMessage to: targetReference [
	| promise response |
	promise := self promiseClass
		onFulfillDo: [ :normalResponse | response := normalResponse ]
		onRejectDo: [ :exceptionResponse | response := exceptionResponse ].
	promisesLock
		critical: [ self promisesDict at: remoteMessage responseId put: promise ].
	self sendMessage: remoteMessage to: targetReference.
	[ promise wait: self waitForResultTimeoutDuration ]
		on: CcPromiseTimeout
		do: [ :ex | self signalTimeoutResponseOfMessage: remoteMessage ].
	^ response contents
]

{ #category : #sending }
MpTransporter >> serialize: anObject [ 
	^FLSerializer serializeToByteArray: anObject
]

{ #category : #sending }
MpTransporter >> signalTimeoutResponseOfMessage: remoteMessage [
	MpRemoteMessageResultTimeout new
		message: remoteMessage;
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

{ #category : #sending }
MpTransporter >> waitForResultTimeoutDuration [
	^self middleware waitForResultTimeoutDuration
]
