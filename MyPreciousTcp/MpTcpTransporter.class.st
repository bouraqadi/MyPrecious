Class {
	#name : #MpTcpTransporter,
	#superclass : #MpConnectedTransporter,
	#category : #MyPreciousTcp
}

{ #category : #sending }
MpTcpTransporter >> connectionClass [
	^MpTcpConnection
]

{ #category : #initialization }
MpTcpTransporter >> newReceptionService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveBytesFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTcpTransporter >> port: integer [
	receptionService port: integer.

]

{ #category : #receiving }
MpTcpTransporter >> receiveBytesFromStream: stream [
	| connection |
	connection := self newConnection.
	connection socketStream: stream.
	self receiveBytesVia: connection
]

{ #category : #initialization }
MpTcpTransporter >> serverClass [
	^NeTcpServer 
]
