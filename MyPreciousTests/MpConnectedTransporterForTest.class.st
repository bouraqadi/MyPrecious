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
	| connection otherSideConnection |
	connection := self newConnection.
	otherSideConnection := self connectionQueue next.
	connection 
		connectTo: otherSideConnection;
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
