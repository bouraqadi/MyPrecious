Class {
	#name : #MpPersistentConnectionsTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'connectionsDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #connecting }
MpPersistentConnectionsTransporter >> connectTo: targetRemoteReference [
	^connectionsDict 
		at: targetRemoteReference address
		ifAbsentPut: [ self newConnectionTo: targetRemoteReference ]
]

{ #category : #accessing }
MpPersistentConnectionsTransporter >> connectionsDict [
	^connectionsDict
]

{ #category : #initialization }
MpPersistentConnectionsTransporter >> initialize [
	super initialize.
	connectionsDict := Dictionary new.

]

{ #category : #connecting }
MpPersistentConnectionsTransporter >> newConnectionTo: targetRemoteReference [
	| newConnection metaMessage |
	metaMessage := MpSaveConnectionMetaMessage new.
	metaMessage otherSideAddress: self address.
	newConnection := super connectTo: targetRemoteReference.
	newConnection sendObject: metaMessage.
	^newConnection
]

{ #category : #connecting }
MpPersistentConnectionsTransporter >> saveConnection: aConnection to: address [
	connectionsDict at: address put: aConnection
]
