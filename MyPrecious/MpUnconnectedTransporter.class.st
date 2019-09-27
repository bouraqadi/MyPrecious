Class {
	#name : #MpUnconnectedTransporter,
	#superclass : #MpTransporter,
	#traits : 'MpTPostMan',
	#classTraits : 'MpTPostMan classTrait',
	#instVars : [
		'promisesDict',
		'promisesLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpUnconnectedTransporter >> deliverResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #receiving }
MpUnconnectedTransporter >> deliverSynchronousMessage: remoteMessage [
	| response |
	response := self basicDeliverSynchronousMessage: remoteMessage.
	self sendObject: response toAddress: remoteMessage senderAddress
]

{ #category : #initialization }
MpUnconnectedTransporter >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.

]

{ #category : #initialization }
MpUnconnectedTransporter >> newReceptionService [
	^CcService repeat: [ self receiveBytes ]
]

{ #category : #sending }
MpUnconnectedTransporter >> promiseClass [
	^ CcPromise
]

{ #category : #receiving }
MpUnconnectedTransporter >> readBytes [
	self subclassResponsibility
]

{ #category : #receiving }
MpUnconnectedTransporter >> receiveBytes [
	| bytes |
	bytes := self readBytes.
	[ self receiveBytes: bytes ] fork
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

{ #category : #sending }
MpUnconnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetReference [
	| promise response |
	promise := self promiseClass
		onFulfillDo: [ :normalResponse | response := normalResponse ]
		onRejectDo: [ :exceptionResponse | response := exceptionResponse ].
	promisesLock
		critical: [ promisesDict at: remoteMessage responseId put: promise ].
	self sendAsynchronousMessage: remoteMessage to: targetReference.
	[ promise wait: self receptionTimeoutDuration ]
		on: CcPromiseTimeout
		do: [ :ex | self signalReceivingResponseOfRemoteMessage: remoteMessage raisedException: ex ].
	^ response contents
]
