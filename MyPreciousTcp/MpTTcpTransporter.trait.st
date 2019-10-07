Trait {
	#name : #MpTTcpTransporter,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTTcpTransporter >> newReceptionService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveBytesFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTTcpTransporter >> port: integer [
	self receptionService port: integer.

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
