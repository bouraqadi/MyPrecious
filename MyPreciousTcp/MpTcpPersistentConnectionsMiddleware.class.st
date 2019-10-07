Class {
	#name : #MpTcpPersistentConnectionsMiddleware,
	#superclass : #MpTcpMiddleware,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpPersistentConnectionsMiddleware >> transporterClass [
	^MpTcpPersistentConnectionsTransporter
]
