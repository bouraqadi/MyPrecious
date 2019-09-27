Class {
	#name : #MpRemoteMessageResultTimeout,
	#superclass : #MpRemoteMessagingError,
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessageResultTimeout >> description [
	^String streamContents: [: str |
		str nextPutAll: 'Timeout waiting for response for remote message '.
		self printSelectorOn: str]
]
