Trait {
	#name : #MpTPersistentConnection,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpTPersistentConnection >> newReceptionServiceDoing: aBlock [
	^CcService repeat: aBlock
]
