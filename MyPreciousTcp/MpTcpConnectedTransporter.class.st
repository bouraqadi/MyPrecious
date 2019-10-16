Class {
	#name : #MpTcpConnectedTransporter,
	#superclass : #MpReliableConnectedTransporter,
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
			self acceptConnectionWith: stream ];
		yourself
]

{ #category : #accessing }
MpTcpConnectedTransporter >> port: integer [
	self connectionService port: integer.

]

{ #category : #initialization }
MpTcpConnectedTransporter >> serverClass [
	^NeTcpServer 
]
