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
		receiveQueue: self connectionQueue next;
		sendQueue: self connectionQueue next;
		startReceiving
]

{ #category : #connecting }
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
MpConnectedTransporterForTest >> newConnectionHandlingService [
	^CcService repeat: [ self acceptConnections ]
]

{ #category : #sending }
MpConnectedTransporterForTest >> registry [
	^self middleware registry
]
