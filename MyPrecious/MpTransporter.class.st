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
MpTransporter >> deliverMessage: remoteMessage [
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
	self sendObject: response to: remoteMessage senderAddress
]

{ #category : #receiving }
MpTransporter >> deliverResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #receiving }
MpTransporter >> exceptionResponseClass [
	^ MpExceptionRemoteResponse
]

{ #category : #receiving }
MpTransporter >> incomingBytes [
	self subclassResponsibility
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
MpTransporter >> receiveBytes [
	self receiveBytes: self incomingBytes
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

{ #category : #sending }
MpTransporter >> sendBytes: bytes to: address [
	self subclassResponsibility

]

{ #category : #sending }
MpTransporter >> sendMessage: remoteMessage [
	| promise response |
	promise := self promiseClass
		onFulfillDo: [ :normalResponse | response := normalResponse ]
		onRejectDo: [ :exceptionResponse | response := exceptionResponse ].
	promisesLock critical: [ 
		self promisesDict 
			at: remoteMessage responseId 
			put: promise ].
	[self sendObject: remoteMessage to: remoteMessage targetAddress] 
		on: Exception
		do: [ :ex | self signalSendingMessage: remoteMessage raised: ex ].
	[ promise wait: self waitForResultTimeoutDuration ]
		on: CcPromiseTimeout
		do:
			[ :ex | self signalTimeoutOfPromise: promise forResultOfMessage: remoteMessage ].
	^ response contents
]

{ #category : #sending }
MpTransporter >> sendMessage: localMessage targetReference: remoteReference receiver: aProxy [
	| remoteMessage |
	remoteMessage := MpRemoteMessage new.
	remoteMessage
		selector: localMessage selector;
		arguments: localMessage arguments;
		targetAddress: remoteReference address;
		receiver: aProxy;
		senderAddress: self address; 
		responseId: self newId.
	^self sendMessage: remoteMessage 

]

{ #category : #sending }
MpTransporter >> sendObject: anObject to: address [
	| marshalledObject bytes |
	marshalledObject := self marshal: anObject.
	bytes := self serialize: marshalledObject.
	self sendBytes: bytes to: address
]

{ #category : #sending }
MpTransporter >> serialize: anObject [ 
	^FLSerializer serializeToByteArray: anObject
]

{ #category : #sending }
MpTransporter >> signalSendingMessage: aMessage raised: exception [
	MpRemoteMessageSendError new
		message: aMessage;
		remoteException: exception;
		signal
]

{ #category : #sending }
MpTransporter >> signalTimeoutOfPromise: promise forResultOfMessage: aMessage [
	MpRemoteMessageResultTimeout new
		resultPromise: promise;
		message: aMessage;
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
