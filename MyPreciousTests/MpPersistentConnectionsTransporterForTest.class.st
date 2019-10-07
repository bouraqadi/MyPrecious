Class {
	#name : #MpPersistentConnectionsTransporterForTest,
	#superclass : #MpPersistentConnectionsTransporter,
	#traits : 'MpTConnectedTransporterForTest',
	#classTraits : 'MpTConnectedTransporterForTest classTrait',
	#instVars : [
		'connectionQueue',
		'allReceptionServices'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #accessing }
MpPersistentConnectionsTransporterForTest >> connectionQueue [
	^connectionQueue
]

{ #category : #accessing }
MpPersistentConnectionsTransporterForTest >> initialize [
	super initialize.
	connectionQueue := SharedQueue new.
	allReceptionServices := Set new
]

{ #category : #receiving }
MpPersistentConnectionsTransporterForTest >> startServiceReceivingVia: connection [
	| service |
	service := CcService repeat: [ self receiveBytesVia: connection ].
	service start.
	allReceptionServices add: service
]
