Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#category : #'MyPrecious-Kernel'
}

{ #category : #sending }
MpConnectedTransporter >> connectTo: targetRemoteReference [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnectedTransporter >> receiveBytesVia: connection [
	self subclassResponsibility
]

{ #category : #receiving }
MpConnectedTransporter >> receiveObjectVia: connection [
	| bytes |
	bytes := self receiveBytesVia: connection.
	^self materializeAndUnmarshal: bytes.
	
]

{ #category : #sending }
MpConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection |
	connection := self connectTo: targetRemoteReference.
	self sendObject: remoteMessage via: connection
]

{ #category : #sending }
MpConnectedTransporter >> sendBytes: bytes via: connection [
	self subclassResponsibility
]

{ #category : #sending }
MpConnectedTransporter >> sendObject: anObject via: connection [
	| bytes |
	bytes := self marshalAndSerialize: anObject.
	self sendBytes: bytes via: connection
]

{ #category : #sending }
MpConnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection response |
	connection := self connectTo: targetRemoteReference.
	self sendObject: remoteMessage via: connection.
	response := self receiveObjectVia: connection.
	^response contents
]
