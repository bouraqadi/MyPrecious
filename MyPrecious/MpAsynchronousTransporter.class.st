Class {
	#name : #MpAsynchronousTransporter,
	#superclass : #MpTransporter,
	#instVars : [
		'promisesDict',
		'promisesLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpAsynchronousTransporter >> deliverAsynchronousMessage: remoteMessage [
	remoteMessage send 

]

{ #category : #receiving }
MpAsynchronousTransporter >> deliverResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #receiving }
MpAsynchronousTransporter >> deliverSynchronousMessage: remoteMessage [
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

{ #category : #initialization }
MpAsynchronousTransporter >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.

]

{ #category : #initialization }
MpAsynchronousTransporter >> newReceptionService [
	^CcService repeat: [ self receiveBytes ]
]

{ #category : #sending }
MpAsynchronousTransporter >> promiseClass [
	^ CcPromise
]

{ #category : #receiving }
MpAsynchronousTransporter >> readBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpAsynchronousTransporter >> receiveBytes [
	self receiveBytes: self readBytes
]

{ #category : #receiving }
MpAsynchronousTransporter >> receiveBytes: bytes [
	| receivedObject  |
	receivedObject := self materializeFrom: bytes.
	self receiveObject: receivedObject
]

{ #category : #receiving }
MpAsynchronousTransporter >> receiveObject: anObject [
	| unmarshalledObject |
	unmarshalledObject := self unmarshal: anObject.
	unmarshalledObject deliverByTransporter: self
]

{ #category : #sending }
MpAsynchronousTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	[
		self sendObject: remoteMessage toAddress: targetRemoteReference address
	] on: Error do: [ : ex | 
		MpCouldNotDeliverMessageError new
			message: remoteMessage;
			originalException: ex;
			signal
	]
]

{ #category : #sending }
MpAsynchronousTransporter >> sendBytes: bytes toAddress: address [
	self subclassResponsibility

]

{ #category : #sending }
MpAsynchronousTransporter >> sendObject: anObject toAddress: address [
	| marshalledObject bytes |
	marshalledObject := self marshal: anObject.
	bytes := self serialize: marshalledObject.
	self sendBytes: bytes toAddress: address
]

{ #category : #sending }
MpAsynchronousTransporter >> sendSynchronousMessage: remoteMessage to: targetReference [
	| promise response |
	promise := self promiseClass
		onFulfillDo: [ :normalResponse | response := normalResponse ]
		onRejectDo: [ :exceptionResponse | response := exceptionResponse ].
	promisesLock
		critical: [ promisesDict at: remoteMessage responseId put: promise ].
	self sendAsynchronousMessage: remoteMessage to: targetReference.
	[ promise wait: self waitForResultTimeoutDuration ]
		on: CcPromiseTimeout
		do: [ :ex | self signalTimeoutResponseOfMessage: remoteMessage ].
	^ response contents
]
