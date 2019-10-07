Trait {
	#name : #MpTConnectedTransporterForTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #receiving }
MpTConnectedTransporterForTest >> acceptConnections [
	| connection |
	connection := self newConnection.
	connection 
		receiveQueue: self connectionQueue next;
		sendQueue: self connectionQueue next;
		startReceiving
]

{ #category : #receiving }
MpTConnectedTransporterForTest >> connectionQueue [
	self explicitRequirement
]

{ #category : #initialization }
MpTConnectedTransporterForTest >> newReceptionService [
	^CcService repeat: [ self acceptConnections ]
]

{ #category : #sending }
MpTConnectedTransporterForTest >> registry [
	^self middleware registry
]
