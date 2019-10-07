Trait {
	#name : #MpTOneShotConnection,
	#category : #'MyPrecious-ToDelete'
}

{ #category : #'instance creation' }
MpTOneShotConnection >> newReceptionServiceDoing: aBlock [
	^CcService do: aBlock
]
