Class {
	#name : #MpConnectedTransporterForTest,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'connectionQueue'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #receiving }
MpConnectedTransporterForTest >> acceptConnections [
	| receptionQueue connection |
	receptionQueue := connectionQueue next.
	connection := self newConnection.
	connection communicationQueue: receptionQueue.
	[ self receiveBytesVia: connection ] fork
]

{ #category : #sending }
MpConnectedTransporterForTest >> connectionClass [
	^MpConnectionForTest
]

{ #category : #accessing }
MpConnectedTransporterForTest >> connectionQueue [
	^ connectionQueue
]

{ #category : #initialization }
MpConnectedTransporterForTest >> initialize [
	super initialize.
	connectionQueue := SharedQueue new
]

{ #category : #initialization }
MpConnectedTransporterForTest >> newReceptionService [
	^CcService repeat: [ self acceptConnections ]
]

{ #category : #receiving }
MpConnectedTransporterForTest >> receiveBytesVia: connection [
	connection deliverReceivedObject
]

{ #category : #sending }
MpConnectedTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #sending }
MpConnectedTransporterForTest >> sendBytes: bytes via: sharedQueue [
	sharedQueue nextPut: bytes
]
