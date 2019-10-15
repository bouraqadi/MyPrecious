Class {
	#name : #MpTransporter,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'promisesDict',
		'promisesLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpTransporter >> address [
	^self middleware address
]

{ #category : #receiving }
MpTransporter >> deliverResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #initialization }
MpTransporter >> initialize [
	super initialize.
	promisesDict := Dictionary new.
	promisesLock := Mutex new.

]

{ #category : #activity }
MpTransporter >> isStarted [
	^self subclassResponsibility
]

{ #category : #activity }
MpTransporter >> isStopped [
	^self isStarted not
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

{ #category : #sending }
MpTransporter >> newPromiseAt: id [
	| newPromise |
	newPromise := self promiseClass new.
	promisesLock critical: [ promisesDict at: id put: newPromise ].
	^newPromise
]

{ #category : #accessing }
MpTransporter >> processingPriority [
	^self middleware processingPriority
]

{ #category : #sending }
MpTransporter >> promiseClass [
	^ CcPromise
]

{ #category : #accessing }
MpTransporter >> receptionPriority [
	^self subclassResponsibility
]

{ #category : #initialization }
MpTransporter >> receptionPriority: anInteger [
	self subclassResponsibility
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
MpTransporter >> sendSynchronousMessage: remoteMessage to: targetReference [
	| promise response |
	promise := self newPromiseAt: remoteMessage responseId.
	promise
		onFulfillDo: [ :normalResponse | response := normalResponse ]
		onRejectDo: [ :exceptionResponse | response := exceptionResponse ].
	self sendAsynchronousMessage: remoteMessage to: targetReference.
	self waitResponseFor: remoteMessage onPromise: promise.
	^ response contents
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
	self subclassResponsibility
]

{ #category : #activity }
MpTransporter >> stop [
	self subclassResponsibility
]

{ #category : #receiving }
MpTransporter >> unmarshal: anObject [ 
	^self marshaller unmarshal: anObject.
]

{ #category : #sending }
MpTransporter >> waitResponseFor: remoteMessage onPromise: promise [
	[ promise wait: self receptionTimeoutDuration ]
		on: CcPromiseTimeout
		do: [ :ex | 
			self
				signalReceivingResponseOfRemoteMessage: remoteMessage
				raisedException: ex ]
]
