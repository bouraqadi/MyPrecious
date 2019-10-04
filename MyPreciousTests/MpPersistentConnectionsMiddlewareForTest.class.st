Class {
	#name : #MpPersistentConnectionsMiddlewareForTest,
	#superclass : #MpMiddlewareForTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #initialization }
MpPersistentConnectionsMiddlewareForTest >> transporterClass [
	^MpPersistentConnectionsTransporterForTest 
]
