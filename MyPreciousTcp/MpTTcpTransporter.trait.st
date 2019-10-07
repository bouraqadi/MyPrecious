Trait {
	#name : #MpTTcpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #sending }
MpTTcpTransporter >> connectionClass [
	^MpTcpConnection
]

{ #category : #initialization }
MpTTcpTransporter >> newReceptionService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self startServiceReceivingFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTTcpTransporter >> port: integer [
	self receptionService port: integer.

]

{ #category : #receiving }
MpTTcpTransporter >> receiveBytesFromStream: stream [
	| connection |
	connection := self newConnection.
	connection socketStream: stream.
	self receiveBytesVia: connection
]

{ #category : #initialization }
MpTTcpTransporter >> serverClass [
	^NeTcpServer 
]

{ #category : #initialization }
MpTTcpTransporter >> startServiceReceivingFromStream: stream [
	self explicitRequirement
]
