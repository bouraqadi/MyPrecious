Class {
	#name : #MpTcpPersistentConnectionsMiddleware,
	#superclass : #MpTcpMiddleware,
	#category : #'MyPrecious-ToDelete'
}

{ #category : #initialization }
MpTcpPersistentConnectionsMiddleware >> transporterClass [
	^MpTcpPersistentConnectionsTransporter
]
