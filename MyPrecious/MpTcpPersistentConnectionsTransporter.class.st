Class {
	#name : #MpTcpPersistentConnectionsTransporter,
	#superclass : #MpPersistentConnectionsTransporter,
	#traits : 'MpTTcpTransporter',
	#classTraits : 'MpTTcpTransporter classTrait',
	#category : #'MyPrecious-ToDelete'
}

{ #category : #connecting }
MpTcpPersistentConnectionsTransporter >> connectionClass [
	^MpTcpPersistentConnection
]
