Class {
	#name : #MpCouldNotDeliverMessageError,
	#superclass : #MpRemoteMessagingError,
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpCouldNotDeliverMessageError >> defaultMessageText [
	^'Could not deliver remote message '
]
