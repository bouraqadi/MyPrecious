Class {
	#name : #MpConnectedTransporter,
	#superclass : #MpTransporter,
	#category : #'MyPrecious-Kernel'
}

{ #category : #sending }
MpConnectedTransporter >> basicSendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection |
	connection := self connectTo: targetRemoteReference.
	connection sendObject: remoteMessage.
	^ connection
]

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
MpConnectedTransporter >> receiveBytesVia: connection [
	connection deliverReceivedObject
]

{ #category : #sending }
MpConnectedTransporter >> sendAsynchronousMessage: remoteMessage to: targetRemoteReference [
	[ ^ self
			basicSendAsynchronousMessage: remoteMessage
			to: targetRemoteReference 
	]
		on: Error
		do: [ :ex | self signalSendingRemoteMessage: remoteMessage raisedException: ex ]
]

{ #category : #sending }
MpConnectedTransporter >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	| connection response |
	connection := self sendAsynchronousMessage: remoteMessage to: targetRemoteReference.
	[response := connection receiveObject] 
		on: Error 
		do: [: ex | self signalReceivingResponseOfRemoteMessage: remoteMessage raisedException: ex].
	^response contents
]
