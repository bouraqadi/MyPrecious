Class {
	#name : #MpChannel,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'promisesDict',
		'promisesLock'
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
			id: remoteMessage resultId
			result: result 
	] on: Exception do: [ :exception | 
		response := self exceptionResponseClass
				id: remoteMessage resultId
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
MpChannel >> send: aMessage to: receiver [
	| promise resultId resultBlock semaphore |
	resultId := self newId.
	semaphore := Semaphore new.		
	promise := CcPromise
		onFulfillDo: [: answer | 
			resultBlock := [answer].
			semaphore signal] 
		onRejectDo: [: exception | 
			resultBlock := [exception signal].
			semaphore signal].
	promisesLock critical: [
		promisesDict at: resultId put: promise].
	self send: aMessage to: receiver resultId: resultId.
	semaphore wait.
	^ resultBlock value
]

{ #category : #communicating }
MpChannel >> send: aMessage to: receiver resultId: resultId [
	| remoteMessage |
	remoteMessage := MpRemoteMessage
		selector: aMessage selector
		arguments: aMessage arguments
		receiver: receiver 
		resultId: resultId.
	self sendObject: remoteMessage
]

{ #category : #communicating }
MpChannel >> sendBytes: bytes [
	self subclassResponsibility

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
MpChannel >> unmarshal: anObject [ 
	^self marshaller unmarshal: anObject.
]
