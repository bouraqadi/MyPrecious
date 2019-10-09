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
	| connection queues |
	connection := self newConnection.
	queues := self connectionQueue next.
	connection 
		receiveQueue: queues first;
		sendQueue: queues last;
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
