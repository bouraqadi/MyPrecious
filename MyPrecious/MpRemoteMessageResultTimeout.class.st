Class {
	#name : #MpRemoteMessageResultTimeout,
	#superclass : #MpRemoteMessagingError,
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessageResultTimeout >> defaultMessageText [
	^'Timeout waiting for response for remote message '.

]
