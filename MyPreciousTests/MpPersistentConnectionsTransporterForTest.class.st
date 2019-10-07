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

{ #category : #connecting }
MpPersistentConnectionsTransporterForTest >> connectionClass [
	^MpPersistentConnectionForTest
]

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
