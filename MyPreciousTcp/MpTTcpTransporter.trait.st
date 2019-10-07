Trait {
	#name : #MpTTcpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTTcpTransporter >> newConnectionHandlingService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveBytesFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTTcpTransporter >> port: integer [
	self connectionHandlingService port: integer.

]

{ #category : #receiving }
MpTTcpTransporter >> receiveBytesFromStream: stream [
	self newConnection
		socketStream: stream;
		startReceiving
]

{ #category : #initialization }
MpTTcpTransporter >> serverClass [
	^NeTcpServer 
]
