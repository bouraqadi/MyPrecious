Class {
	#name : #MpPersistentConnectionsTransporterForTest,
	#superclass : #MpPersistentConnectionsTransporter,
	#traits : 'MpTConnectedTransporterForTest',
	#classTraits : 'MpTConnectedTransporterForTest classTrait',
	#instVars : [
		'connectionQueue'
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
	connectionQueue := SharedQueue new
]
