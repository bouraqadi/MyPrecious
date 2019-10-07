Class {
	#name : #MpPersistentConnectionsMiddlewareForTest,
	#superclass : #MpMiddlewareForTest,
	#category : #'MyPrecious-ToDelete'
}

{ #category : #initialization }
MpPersistentConnectionsMiddlewareForTest >> transporterClass [
	^MpPersistentConnectionsTransporterForTest 
]
