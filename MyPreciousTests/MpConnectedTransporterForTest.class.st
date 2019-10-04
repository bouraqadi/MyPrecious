Class {
	#name : #MpConnectedTransporterForTest,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'connectionQueue'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #receiving }
MpConnectedTransporterForTest >> acceptConnections [
	| connection |
	connection := self newConnection.
	connection 
		receiveQueue: connectionQueue next;
		sendQueue: connectionQueue next.
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

{ #category : #sending }
MpConnectedTransporterForTest >> registry [
	^self middleware registry
]

{ #category : #sending }
MpConnectedTransporterForTest >> sendBytes: bytes via: sharedQueue [
	sharedQueue nextPut: bytes
]
