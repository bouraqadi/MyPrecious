Class {
	#name : #MpCouldNotDeliverMessageError,
	#superclass : #MpMessageSendExceptionWrapper,
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpCouldNotDeliverMessageError >> description [
	^String streamContents: [ : str|
		str << 'Could not deliver remote message '.
		self printSelectorOn: str.
	]
]
