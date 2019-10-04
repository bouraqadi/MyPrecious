Class {
	#name : #MpPersistentConnectionsTransporter,
	#superclass : #MpConnectedTransporter,
	#instVars : [
		'connectionsDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #sending }
MpPersistentConnectionsTransporter >> connectTo: targetRemoteReference [
	^connectionsDict 
		at: targetRemoteReference address
		ifAbsentPut: [ super connectTo: targetRemoteReference ]
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
