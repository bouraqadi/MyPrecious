Class {
	#name : #MpConnectedTransporterForTest,
	#superclass : #MpConnectedTransporter,
	#category : #'MyPrecious-Tests'
}

{ #category : #sending }
MpConnectedTransporterForTest >> connectTo: targetRemoteReference [
	| targetTransporter sharedQueue |
	targetTransporter := self registry at: targetRemoteReference address.
	sharedQueue := SharedQueue new.
	targetTransporter receiveVia: sharedQueue.
	^sharedQueue
	
]

{ #category : #sending }
MpConnectedTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #sending }
MpConnectedTransporterForTest >> sendSynchronousMessage: remoteMessage to: targetRemoteReference [
	| sharedQueue |
	sharedQueue 
]
