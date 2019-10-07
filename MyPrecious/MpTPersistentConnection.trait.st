Trait {
	#name : #MpTPersistentConnection,
	#category : #'MyPrecious-ToDelete'
}

{ #category : #'instance creation' }
MpTPersistentConnection >> newReceptionServiceDoing: aBlock [
	^CcService repeat: aBlock
]
