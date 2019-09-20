Class {
	#name : #MpTcpTransporter,
	#superclass : #MpTransporter,
	#category : #MyPreciousTcp
}

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

{ #category : #initialization }
MpTcpTransporter >> serverClass [
	^NeTcpServer 
]
