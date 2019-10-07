Trait {
	#name : #MpTOneShotConnection,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpTOneShotConnection >> newReceptionServiceDoing: aBlock [
	^CcService do: aBlock
]
