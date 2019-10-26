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
	| otherSideConnection |
	otherSideConnection := self connectionQueue nextOrNil.
	otherSideConnection ifNil: [ ^self ].
	self acceptConnectionWith: otherSideConnection
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
	^TKTParameterizableService new
		step: [self acceptConnections];
		stepDelay: 0 milliSecond;
		yourself

]

{ #category : #sending }
MpConnectedTransporterForTest >> registry [
	^self middleware registry
]
