"
Ensure a reliable communication by forcing the transporter to recreate a new connection.
This is done by simply removing the current connection.
Upon the next message send, the transporter will create a new connection, which in turn will make the other side create a new connection and register it instead of the existing one if any.
"
Class {
	#name : #MpRecreateConnection,
	#superclass : #MpRepeatedAttempts,
	#category : #'MyPrecious-Connected'
}

{ #category : #sending }
MpRecreateConnection >> handleException: exception onAsynchronousMessage: remoteMessage to: targetRemoteReference [
	self removeConnectionTo: targetRemoteReference
]

{ #category : #sending }
MpRecreateConnection >> handleException: exception onSynchronousMessage: remoteMessage to: targetRemoteReference [
	self removeConnectionTo: targetRemoteReference
]

{ #category : #sending }
MpRecreateConnection >> removeConnectionTo: targetRemoteReference [
	self transporter removeConnectionTo: targetRemoteReference
]
