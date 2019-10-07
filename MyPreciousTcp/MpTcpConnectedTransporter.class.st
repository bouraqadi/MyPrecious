Class {
	#name : #MpTcpConnectedTransporter,
	#superclass : #MpConnectedTransporter,
	#category : #MyPreciousTcp
}

{ #category : #connecting }
MpTcpConnectedTransporter >> connectionClass [
	^MpTcpConnection
]

{ #category : #initialization }
MpTcpConnectedTransporter >> newConnectionHandlingService [
	^self serverClass new
		withCommunicationStreamDo: [ : stream | 
			self receiveBytesFromStream: stream ];
		yourself
]

{ #category : #accessing }
MpTcpConnectedTransporter >> port: integer [
	self connectionHandlingService port: integer.

]

{ #category : #receiving }
MpTcpConnectedTransporter >> receiveBytesFromStream: stream [
	self newConnection
		socketStream: stream;
		startReceiving
]

{ #category : #initialization }
MpTcpConnectedTransporter >> serverClass [
	^NeTcpServer 
]
