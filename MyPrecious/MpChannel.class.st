Class {
	#name : #MpChannel,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'promisesDict',
		'promisesLock',
		'receptionService'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpChannel class >> middleware: aMiddleware [
	^self new
		middleware: aMiddleware;
		yourself
]

{ #category : #communicating }
MpChannel >> exceptionResponseClass [
	^ MpExceptionRemoteResponse
]

{ #category : #initialization }
MpChannel >> initialize [
	super initialize.
	promisesDict := WeakValueDictionary new.
	promisesLock := Mutex new.
	receptionService := CcService repeat: [ self receptionStep ]
]

{ #category : #activity }
MpChannel >> isStarted [
	^receptionService isStarted
]

{ #category : #activity }
MpChannel >> isStopped [
	^receptionService isStopped
]

{ #category : #communicating }
MpChannel >> marshal: anObject [ 
	^self marshaller marshal: anObject 


]

{ #category : #accessing }
MpChannel >> marshaller [
	^self middleware marshaller
]

{ #category : #communicating }
MpChannel >> materializeFrom: bytes [ 
	^FLMaterializer materializeFromByteArray: bytes
]

{ #category : #communicating }
MpChannel >> normalResponseClass [
	^ MpNormalRemoteResponse
]

{ #category : #accessing }
MpChannel >> promisesDict [
	^ promisesDict
]

{ #category : #communicating }
MpChannel >> receiveBytes [
	self subclassResponsibility
]

{ #category : #communicating }
MpChannel >> receiveBytes: bytes [
	| receivedObject  |
	receivedObject := self materializeFrom: bytes.
	self receiveObject: receivedObject
]

{ #category : #communicating }
MpChannel >> receiveMessage: remoteMessage [
	| result response |
	[ 
		result := remoteMessage send.
		response := self normalResponseClass
			id: remoteMessage responseId
			result: result 
	] on: Exception do: [ :exception | 
		response := self exceptionResponseClass
				id: remoteMessage responseId
				exception: exception 
	].
	self sendObject: response
]

{ #category : #communicating }
MpChannel >> receiveObject: anObject [
	| unmarshalledObject |
	unmarshalledObject := self unmarshal: anObject.
	unmarshalledObject receivedByChannel: self
]

{ #category : #communicating }
MpChannel >> receiveResponse: remoteResponse [
	| promise |
	promise := promisesLock critical: [
		promisesDict at: remoteResponse id ifAbsent: [^self]].
	remoteResponse trigger: promise

]

{ #category : #communicating }
MpChannel >> receptionStep [
	self receiveBytes: self receiveBytes
]

{ #category : #communicating }
MpChannel >> sendBytes: bytes [
	self subclassResponsibility

]

{ #category : #communicating }
MpChannel >> sendMessageNoWait: aMessage to: receiver responseId: responseId [
	| remoteMessage |
	remoteMessage := MpRemoteMessage
		selector: aMessage selector
		arguments: aMessage arguments
		receiver: receiver 
		responseId: responseId.
	self sendObject: remoteMessage
]

{ #category : #communicating }
MpChannel >> sendMessageSynchronously: aMessage to: receiver [
	| promise resultId resultBlock |
	resultId := self newId.
	promise := CcPromise
		onFulfillDo: [: answer | 
			resultBlock := [answer]] 
		onRejectDo: [: exception | 
			resultBlock := [exception signal]].
	promisesLock critical: [
		promisesDict at: resultId put: promise].
	[self sendMessageNoWait: aMessage to: receiver responseId: resultId] 
		on: Exception 
		do: [: ex | self signalErrorSendingMessage: aMessage].
	[promise wait: self waitForResultTimeoutDuration] 
		on: CcPromiseTimeout 
		do: [: ex | self signalTimeoutOfPromise: promise forResultOfMessage: aMessage].
	^ resultBlock value
]

{ #category : #communicating }
MpChannel >> sendObject: anObject [
	| marshalledObject bytes |
	marshalledObject := self marshal: anObject.
	bytes := self serialize: anObject.
	self sendBytes: bytes
]

{ #category : #communicating }
MpChannel >> serialize: anObject [ 
	^FLSerializer serializeToByteArray: anObject
]

{ #category : #communicating }
MpChannel >> signalErrorSendingMessage: aMessage [
	MpRemoteMessageSendError new
		message: aMessage;
		signal
]

{ #category : #communicating }
MpChannel >> signalTimeoutOfPromise: promise forResultOfMessage: aMessage [
	MpRemoteMessageResultTimeout new
		resultPromise: promise;
		message: aMessage;
		signal
]

{ #category : #activity }
MpChannel >> start [
	receptionService start
]

{ #category : #activity }
MpChannel >> stop [
	receptionService stop
]

{ #category : #communicating }
MpChannel >> unmarshal: anObject [ 
	^self marshaller unmarshal: anObject.
]

{ #category : #communicating }
MpChannel >> waitForResultTimeoutDuration [
	^self middleware waitForResultTimeoutDuration
]
