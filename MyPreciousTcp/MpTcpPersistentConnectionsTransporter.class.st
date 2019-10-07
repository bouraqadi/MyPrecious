Class {
	#name : #MpTcpPersistentConnectionsTransporter,
	#superclass : #MpPersistentConnectionsTransporter,
	#traits : 'MpTTcpTransporter',
	#classTraits : 'MpTTcpTransporter classTrait',
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpPersistentConnectionsTransporter >> startServiceReceivingFromStream: stream [
	| service |
	service := CcService repeat: [self receiveBytesFromStream: stream].
	service start
]
