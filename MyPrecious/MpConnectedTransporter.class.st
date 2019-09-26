Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#category : #'MyPrecious-Kernel'
}

{ #category : #sending }
MpConnectedTransporter >> connectTo: targetRemoteReference [
	^self newConnection
		connectTo: targetRemoteReference;
		yourself
		
]

{ #category : #sending }
MpConnectedTransporter >> connectionClass [
	self subclassResponsibility
]

{ #category : #sending }
MpConnectedTransporter >> newConnection [
	^self connectionClass new
		transporter: self;
		yourself
]

{ #category : #receiving }
MpConnectedTransporter >> receiveVia: connection [
	connection deliverReceivedObject.

]

{ #category : #sending }
MpConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection |
	connection := self connectTo: targetRemoteReference.
	connection sendObject: remoteMessage
]

{ #category : #sending }
MpConnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection response |
	connection := self connectTo: targetRemoteReference.
	connection sendObject: remoteMessage.
	response := connection receiveObject.
	^response contents
]
