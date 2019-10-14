Class {
	#name : #MpConnectedTransporterForTest,
	#superclass : #MpReliableConnectedTransporter,
	#instVars : [
		'connectionQueue'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #receiving }
MpConnectedTransporterForTest >> acceptConnections [
	| connection otherSideConnection |
	otherSideConnection := self connectionQueue next.
	connection := self connectionAt: otherSideConnection address ifAbsent: [ self newConnection ].
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
