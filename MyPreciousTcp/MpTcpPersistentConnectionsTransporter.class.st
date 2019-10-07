Class {
	#name : #MpTcpPersistentConnectionsTransporter,
	#superclass : #MpPersistentConnectionsTransporter,
	#traits : 'MpTTcpTransporter',
	#classTraits : 'MpTTcpTransporter classTrait',
	#category : #MyPreciousTcp
}

{ #category : #connecting }
MpTcpPersistentConnectionsTransporter >> connectionClass [
	^MpTcpPersistentConnection
]
