Class {
	#name : #MpChannel,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpChannel class >> middleware: aMiddleware [
	^self new
		middleware: aMiddleware;
		yourself
]

{ #category : #protocol }
MpChannel >> marshal: anObject [ 
	^self marshaller marshal: anObject 


]

{ #category : #accessing }
MpChannel >> marshaller [
	^self middleware marshaller
]

{ #category : #protocol }
MpChannel >> materializeFrom: bytes [ 
	^self protocol materializeFromByteArray: bytes
]

{ #category : #accessing }
MpChannel >> protocol [
	^self protocolClass new
]

{ #category : #accessing }
MpChannel >> protocolClass [
	^MpProtocol
]

{ #category : #communicating }
MpChannel >> receiveBytes: bytes [
	| receivedObject unmarshalledObject  |
	receivedObject := self materializeFrom: bytes.
	unmarshalledObject := self unmarshal: receivedObject.
	self receiveObject: unmarshalledObject
]

{ #category : #communicating }
MpChannel >> receiveObject: anObject [
	anObject receivedByChannel: self
]

{ #category : #communicating }
MpChannel >> sendBytes: aCollection [ 
	self subclassResponsibility
]

{ #category : #communicating }
MpChannel >> sendObject: anObject [
	| marshalledObject bytes |
	marshalledObject := self marshal: anObject.
	bytes := self serialize: marshalledObject.
	self sendBytes: bytes
]

{ #category : #protocol }
MpChannel >> serialize: remoteMessage [ 
	^self protocol serializeToByteArray: remoteMessage
]

{ #category : #protocol }
MpChannel >> unmarshal: anObject [ 
	^self marshaller unmarshal: anObject.
]
